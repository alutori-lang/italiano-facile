# Tester 3 report — every option, payment and ad

App: "Italian Words: Learn & Play" (simple_flutter_app_651) · date 2026-10-21
Command: `flutter test test/tester3` → **61 passed, 7 failed** (68 tests).
No file under `lib/` was changed.

## Test files (test/tester3/)

| File | What it covers |
|------|----------------|
| `t3_harness.dart` | Fakes: `FakeStore` (implements `InAppPurchase`, answers through `purchaseStream`, configurable availability / products / errors / restore reply and delay), `FakeNotifications`, `AdSdkMock` (mocks the AdMob, UMP and ATT platform channels and logs every call in order, configurable `canRequestAds`, consent latency, init failure), offline `http` client. `pumpT3App` builds the real app with injected services and runs the same startup as `main.dart`; `restartPrefs` rebuilds SharedPreferences from what was saved. |
| `settings_t3_test.dart` | translation language (first-launch sheet not dismissible by barrier or back, Settings row, Search header pill, dismiss without change); slow audio; dark mode (theme really changes); reminder on/off (permission, schedule 19:00, cancel), time picker cancel / OK, time row; reset progress cancel / confirm (what is wiped, what is kept); reset with reminder on; privacy-options row calls `showPrivacyOptionsForm`; privacy page; about page; remove-ads row price + paywall; test-ids notice hidden for buyers |
| `purchase_t3_test.dart` | unit: price from store, store unavailable, isAvailable throws, buy success (non-consumable, completePurchase, saved), cancel, pending→purchased, error, product not found, buy throws, stream error, restore with / without purchase, restore failing, refund gap, iOS product id. widget: buy button + price, buy→purchased UI, AdsService sync, cancel re-enables button, pending note, error message, store-unavailable message, restore nothing, restore from Settings (fast store), restore from a real-speed store |
| `ads_t3_test.dart` | consent ok → init + interstitial preload; init must wait for consent update; `canRequestAds == false`; buyer → no UMP/init/ad; init failure; iOS ATT order; Android no ATT; banner placement on every screen (Search incl. audio, Today, Quiz list, Settings, Paywall = none; Topics and quiz result = one); buyer gets no banner/interstitial; consent refused → no banner; mid-session purchase stops ads; interstitial rule boundaries (0–179 s blocked, 3:00 allowed, 2:59 after last blocked, clock moved back); finished quiz in first 3 min shows nothing; source scan: interstitial only from quiz result, banner only in Topics + quiz result |
| `offline_restart_t3_test.dart` | all tabs / topic / search / settings / paywall with network and store down; Search online offline, HTTP 500, no answer (8 s timeout), success card + only the typed word is sent; restart keeps my words, streak (and continues next day), learned counters, best score, recent searches, personal id, dark, slow audio, reminder + time, translation language, purchase (offline, without the store); restarted app shows no first-launch sheet, dark theme, buyer state, no SDK init |

## Failures (all 7 are real app problems, not test problems)

### 1. HIGH — Buying "remove_ads" does not stop the ads until the app is restarted
Tests: `purchase_t3_test.dart` "buy -> purchased later through the stream…" (line 244), `ads_t3_test.dart` "buying remove_ads mid-session stops banners and interstitials" (line 221).
Error: `Expected: true Actual: <false>` for `app.ads.adsRemoved`; `Expected: false Actual: <true>` for `app.ads.shouldShowAds` after the purchase.
Cause: `AdsService.adsRemoved` is a plain field copied from `PurchaseService.adsRemoved` only at three moments: `lib/main.dart:52`, `lib/screens/paywall_screen.dart:166` (`_buy`, right after `buyRemoveAds()` returns — i.e. **before** the store answers, because the result always arrives later on `purchaseStream`) and `lib/screens/settings_screen.dart:261`. When `_onPurchaseUpdate` (`lib/services/purchase_service.dart` ~line 125) grants the purchase nothing updates AdsService, so the buyer still gets banners on Topics/quiz result and the interstitial after quizzes for the rest of the session.
Fix idea: make AdsService read the entitlement live (`purchases.adsRemoved`) or add `purchases.addListener(() => ads.adsRemoved = purchases.adsRemoved)` in `main.dart` (and dispose the preloaded interstitial when it flips to true).

### 2. HIGH — Restore from a real store never turns ads off in the session (and the message is stale)
Test: `purchase_t3_test.dart` "restore with a previous purchase from a REAL-speed store (answers after 800 ms)…" (line 363). Error: `Expected: true Actual: <false>` for `app.ads.adsRemoved`.
Cause: same as #1 — `paywall_screen.dart:173` / `settings_screen.dart:261` copy `adsRemoved` after `restore()` which only waits one `Duration.zero` (`purchase_service.dart` `restore()`), long before Google Play / App Store reply. The Italian text now says "Richiesta inviata. Se avevi già comprato, la pubblicità sparisce tra pochi secondi." — that promise is false: ads stay until restart. The paywall itself correctly switches to "Pubblicità rimossa" (purchases notifies), so only the ad side is wrong. (With a store that answers instantly — test "restore from Settings with a previous purchase (fast store)" — everything passes.)

### 3. HIGH (policy) — Ads are initialised before the consent answer, and `canRequestAds()` is never checked
Tests: `ads_t3_test.dart` "MobileAds.initialize waits for the consent info update to finish" and "canRequestAds == false: no MobileAds.initialize, no ad requests"; widget test "consent refused (canRequestAds false): no banner request" (line 203, `Expected: <0> Actual: <1>` banner requests).
Recorded SDK call order with a 500 ms consent round trip:
`[ump:requestConsentInfoUpdate, ump:loadAndShowConsentFormIfRequired, MobileAds#initialize, ump:requestConsentInfoUpdate:done]`
With UMP saying `canRequestAds = false`:
`[…, MobileAds#initialize, loadInterstitialAd]` and a banner is requested on Topics.
Cause: `lib/services/ads_service.dart:69-85` — `_requestConsentInfoUpdate` and `_showFormIfRequired` wrap the callback APIs in `Future<void>(() { … })`, which completes immediately instead of when the callback fires, so `start()` (lines 56-60) proceeds to ATT and `MobileAds.instance.initialize()` (line 110) while consent is still being fetched / the form is still on screen; and `_adsAllowed = true` (line 112) is set without `ConsentInformation.instance.canRequestAds()`. In the EU this means ad requests before/without consent (AdMob/UMP policy breach), and on iOS the ATT prompt can appear on top of the consent form.
Fix idea: wrap each callback in a `Completer` and await it; then `if (!await ConsentInformation.instance.canRequestAds()) { _adsAllowed = false; return; }` before init; also re-check after `showPrivacyOptions`.

### 4. MEDIUM — Reset progress silently turns the daily reminder off on disk but not on screen / in the OS
Test: `settings_t3_test.dart` "reset with the reminder on: in-memory settings and saved settings agree" (line 281). Error: `Expected: <true> Actual: <false>` (restarted `SettingsController.reminderOn` vs the live one).
Cause: `PrefsService.resetProgress()` (`lib/services/prefs_service.dart:70-81`) keeps only locale, dark, slow audio, purchase and personal id, so `reminder_on/hour/minute` are deleted; `SettingsController` still holds `reminderOn = true` (switch shows ON) and the notification scheduled by `NotificationService` is never cancelled (`settings_screen.dart:296` only calls `progress.reset()`). After a restart the switch shows OFF while the phone keeps sending the daily reminder, and the chosen time is lost.
Fix idea: add `kReminderOn`, `kReminderHour`, `kReminderMinute` to the keep-set (a reminder is a setting, not progress).

## Other findings (no failing test)

- **Refund / revoked purchase is never handled** (documented by the passing test "KNOWN GAP…"): `purchase_service.dart` only ever writes `ads_removed = true`; nothing sets it back. Google Play refunds and App Store revocations are therefore permanent "no ads". Acceptable for a €3.99 one-off only if the owner agrees; otherwise check `queryPastPurchases` / StoreKit 2 transaction updates at startup.
- `_onPurchaseUpdate` grants the entitlement for any `productID` (no check against `Monetization.productIds`). Harmless with one product; worth a one-line guard.
- `restore()` without anything to restore ends in `idle` (good — not stuck on loading). Restore failing ends in `error` and the paywall shows the generic purchase error.
- Interstitial timing uses `DateTime.now()` directly (`ads_service.dart` `interstitialAllowed`), so "shown after 3 minutes / again after 3 more" can only be unit-tested through the static `interstitialAllowedAt`; an injectable clock would allow a full in-session test. Static rule is correct at all boundaries; a clock moved backwards does not unlock an early ad.
- Settings row `settings-language` is titled `t.interfaceLanguage` = "Lingua dell'app", but it now chooses the **translation** language (interface is always Italian); the sheet note `languageNoteWordTranslations` still says "le altre lingue dell'interfaccia usano l'inglese", which no longer applies (only the ten translation languages are listed). Copy only.
- The "Gestisci consenso pubblicità" row is always visible; Google recommends showing it only when `getPrivacyOptionsRequirementStatus() == required` (and it does nothing for buyers, who never got consent asked).
- Everything checked offline works: tabs, topic, search of known words, settings, paywall with no store. Search online: offline / HTTP 500 / no answer (8 s timeout) all show "Sei offline…" and the button can be pressed again; success shows the Wiktionary card; only the typed word (plus fixed API params) is sent.
- Restart: progress, streak (and its continuation next day), my words, recent searches, best scores, learned counters, settings, reminder time, translation language and the purchase are all kept; the purchase works offline without the store.

## Manual device checklist (cannot be proven in widget tests)

Consent / ATT (EU test device: add the device hash to `ConsentDebugSettings` with `DebugGeography.debugGeographyEea`, or test from an EU SIM):
1. Fresh install → the UMP form appears **before any ad request** (watch `adb logcat | grep -i "Ads"`: no "Ad request" before the form is answered). Currently expected to FAIL (finding #3).
2. Choose "Do not consent"/close → Topics shows no banner, no interstitial after a quiz.
3. Settings → "Gestisci consenso" re-opens the form; changing the answer takes effect without crash.
4. iOS: the ATT system prompt appears only after the UMP form is closed, never on top of it; NSUserTrackingUsageDescription text is in Italian/English as intended.
5. Outside EU: no form, banner appears on Topics and quiz result within a few seconds (test ads, "Test Ad" label).

Ads:
6. Banner only at the bottom of Topics and of the quiz result; never on Search (also while a word is being spoken), Today, Quiz list, quiz play, flashcards, word detail, My words, Settings, Paywall.
7. Launch, finish a quiz within 3 minutes → no interstitial. Wait until 3 min after launch, finish a quiz → one interstitial. Finish another quiz within 3 min → none. Leave a quiz midway → never an interstitial.
8. Airplane mode at launch → no crash, no empty ad gap; turn network on → banner may appear on next Topics visit.

Purchases (Play Console license tester / App Store sandbox; product `remove_ads`, iOS `simple_flutter_app_651_remove_ads`, non-consumable €3.99):
9. Price on paywall and Settings comes from the store in local format.
10. Buy → test card "always approves" → paywall shows "Pubblicità rimossa"; **go back to Topics without restarting: banner must be gone** (currently expected to FAIL, finding #1); finish a quiz after 3 min → no interstitial.
11. Buy → "Slow test card, approves after a few minutes" → "Pagamento in corso…" shown, then ads removed when it approves (also after app restart).
12. Buy → "declines" → error message, Buy button usable again; Buy → back/cancel in the sheet → no error, button usable.
13. Reinstall (or second device, same account) → Settings → Ripristina acquisti → ads removed (check ads disappear in-session — finding #2).
14. Account without purchase → Restore → "Richiesta inviata…" and ads stay.
15. Refund the test order from Play Console → app keeps "no ads" forever (known gap; decide if acceptable).
16. Kill the app during a pending purchase, approve it, reopen → entitlement granted and transaction completed (Play will auto-refund un-acknowledged purchases after 3 days if `completePurchase` is not reached).

Reminder:
17. Turn reminder on → Android 13+ permission prompt; notification arrives at the chosen time; change time → only one notification at the new time; turn off → no notification.
18. Reminder on → Reset progress → restart → check switch state vs. whether the notification still arrives (finding #4).
