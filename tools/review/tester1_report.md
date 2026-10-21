# Tester 1 — every button and every screen

Date: 2026-10-21. App: Italian Words: Learn & Play. No app code under `lib/` was changed.

## Update (re-run after the full dictionary, ~4900 entries)
- Fixed in my test harness: `scrollTo` in `test/tester1/t1_support.dart` now jumps the list back to the top before searching. Grids keep their scroll position, so it could not reach a topic above the current one, such as 'colors'.
- `flutter test test/tester1`: **117 / 117 pass**.
- Full `flutter test`: **301 pass, 6 skipped, 0 fail**.
- Both real bugs listed below are now fixed in lib/ by the builder:
  - `PopScope(canPop: !firstLaunch)` on the first-launch language sheet;
  - the Settings status strip is now scrolled into view.

  My tests for both now pass.
- The Restore warning (no timeout) and the other observations still apply.

## Result (first run, kept for history)

| Suite | Tests | Pass | Fail |
|---|---|---|---|
| `flutter test test/tester1` (new) | 117 | 114 | **3** |
| `flutter test` (everything) | 241 (+6 skipped) | 191 | 44 (41 old acceptance tests + the 3 above) |

- The JSON dictionary (`assets/dict/words.json`) **loads in the tests** through `WordRepository.load()` (setUpAll): 3225 entries in total, all 33 topics have words, every topic has at least 4 (so every topic has a quiz).
- Phone sizes: 360x640 and 430x932, light and dark (4 configs). Every test fails on any exception or RenderFlex overflow, on a tap that does nothing, and on an empty screen.
- TTS is faked on the `flutter_tts` channel, so every speaker is checked to really say the Italian word (and the slow one at rate 0.25). One test runs with no Italian voice and checks that the install guide opens and closes.

## What was tested (test/tester1/)

- `first_launch_language_test.dart`: the JSON loads. The first-launch sheet appears, is titled "Lingua di traduzione", lists exactly the 10 languages (no interface-language menu) and does not close when tapped outside. Each of the 10 languages was chosen from the first-launch sheet, on 360 light and on 430 dark:
  - the sheet closes and the choice is saved;
  - tabs stay in Italian and the layout stays left-to-right;
  - the pill shows the chosen language's name;
  - "pomodoro" shows the translation, explanation and example in that language and script;
  - English does not appear (except when English is the choice);
  - Urdu and Shahmukhi text is right-to-left, every other language left-to-right;
  - Spain shows "el coche", LatAm shows "el carro";
  - typing the translation (in its own script) finds "il pomodoro".

  The Search header pill changes the language and can be closed again. The Android back button was tested on the first-launch sheet.
- `tabs_search_test.dart`:
  - All 4 tabs, with their Italian header titles, and the theme matches the config.
  - Settings icon, then its back arrow.
  - Search for an Italian word: the result card, its speakers (normal and slow), the word detail with its speaker, back, the clear button.
  - A Bengali query, accents ("citta"), a typo ("pomodroo").
  - No result: the "Volevi dire…?" suggestions, opening a suggestion, the speaker on a suggestion row, a nonsense query.
  - Recent searches: a submitted query becomes a chip, the chip works, "clear recents" works.
  - Add to my words:
    - the label changes;
    - the word shows under Search;
    - My words with 1 word has its quiz turned off, with 4 words the quiz runs 4 of 4;
    - removing a word from the detail updates the list;
    - the speaker on a row works.
  - With no Italian voice, the install guide opens and closes.
- `today_quiz_test.dart`:
  - Today:
    - 10 cards ("Parola 1 di 10");
    - card speakers, and tapping the card speaks;
    - add to my words;
    - swipe, then Avanti up to 10;
    - the mini-quiz with 10 questions (9/10, PROMOSSO), back;
    - the streak pill opens Settings.
  - Quiz:
    - "Mix of all": 20 right answers give 20/20 PROMOSSO with no mistakes and no "repeat mistakes", the best score is saved and shown;
    - "Nuovo quiz" works, back arrow in the middle of a quiz;
    - the fruit category with 3 mistakes gives 17/20 NON PROMOSSO: 3 mistake rows, a mistake speaker, the right word shown in Urdu, "repeat mistakes" (3 questions), new quiz;
    - exactly 2 mistakes gives PROMOSSO;
    - every category tile opens a 20-question quiz (360 light, 430 dark).
- `topics_test.dart`:
  - Every one of the 33 topics opens on all 4 configs with:
    - its Italian title and its word count;
    - its word list;
    - Flashcards and Quiz 20 turned on correctly;
    - a working back arrow.
  - Several topics (first, middle, last, smallest):
    - a word row, its speaker and the word card (Gurmukhi);
    - flashcards (Chinese): flip, flip back, speaker, Avanti;
    - the smallest topic's flashcards run to the end and "Fatto" closes them;
    - Quiz 20 from 2 topics is answered to the end (360 dark, 430 light).
- `settings_test.dart`: on all 4 configs:
  - every row is there;
  - the "Lingua di traduzione" row (subtitle and Search pill follow the choice, the interface stays Italian and left-to-right);
  - slow audio (and the normal speaker then really speaks slowly) and dark mode switches;
  - the reminder switch, then the time picker and its OK button;
  - remove ads opens the paywall: Buy gives a "store not available" message, Restore, back arrow;
  - the restore row, the ads consent row;
  - Privacy and About texts, back arrows;
  - Reset with Cancel and Confirm, and the language choice survives a reset.

## Failures in test/tester1 (3)

### 1. The Android back button skips the first-launch language choice (real bug)
- Test: `first_launch_language_test.dart` "T1 first launch: the Android back button does not skip the language choice".
- Error: `Expected: exactly one matching candidate / Actual: Found 0 widgets with type "BottomSheet"`. After `handlePopRoute()` (the system back) the sheet closed with no language chosen (`hasChosenLanguage == false`).
- Likely cause: `lib/screens/settings_screen.dart:307`. `showModalBottomSheet(isDismissible: !firstLaunch, enableDrag: !firstLaunch)` blocks only the barrier and dragging, not the back gesture or button. It needs a `PopScope(canPop: false)` (or the same idea) around the sheet when `firstLaunch` is true. It is called from `lib/screens/home_shell.dart:39`. Afterwards translations quietly follow the phone language.

### 2–3. The "Progressi azzerati" confirmation is not visible on the 360x640 phone (light and dark)
- Test: `settings_test.dart` "T1 settings: reset cancel and confirm (360x640 light|dark)".
- Error: `Expected: true / Actual: <false>`. The reset is done (words and streak cleared), but the confirmation strip is off screen.
- Likely cause: `lib/screens/settings_screen.dart:54`. `_StatusStrip` is added as the first child of the Settings `ListView`, while the user has scrolled down to "Azzera progressi" at the bottom. On a 640-tall phone the list does not fit on one screen (the comment at line 48 says it does), so the user taps Confirm and sees nothing change. The same goes for the Restore status. Possible fixes: scroll to the top when the status is shown, or show it next to the row or pinned at the bottom.

## Warnings (reported, not failed: they need a real device or store)
- **Restore purchases gives no feedback in the test VM.** After the first call, `InAppPurchase.restorePurchases()` never returns. This happens both in the Paywall (no `paywall-status`) and in the Settings Restore row (no status). `lib/services/purchase_service.dart:102-118` has no timeout, so if the store never answers, the user gets no message and the state stays `loading`, which keeps the Buy button turned off. A timeout that falls back to "Nessun acquisto precedente trovato." is worth adding.
- **The ads consent row** (`settings-ads-consent`, `lib/services/ads_service.dart:86`) causes no exception, but nothing visible happens off-device. This needs a device check.

## Other observations (not failing)
- **Overflow at 320 px width** (found by the old suite, outside the 360/430 targets): "A RenderFlex overflowed by 12 pixels on the right". The Row in `HeaderPill` (`lib/ui/widgets/screen_header.dart:101`) overflows in the Search header (`lib/screens/search_screen.dart:130`: language pill plus settings icon inside a 2/5-width slot). It was clean at 360 with all 10 language names.
- **The first-launch sheet fills the whole screen on 360x640.** Title, note and 10 rows are about 660 px tall. Spanish (Spain) and Spanish (LatAm) are below the fold and the list has to be scrolled; there is no visible hint of that. It works, but a compact layout would show all 10 at once.
- **Tapping the Today card speaks** (`lib/screens/today_screen.dart:134`) through `tts.speak` directly, so with no Italian voice it does nothing visible. The speaker buttons open the install guide instead. This is minor and inconsistent.
- **The Today streak pill opens Settings** (`lib/screens/today_screen.dart:107`). It works, but it is an odd destination for a streak.
- The l10n key behind "Lingua di traduzione" is still named `interfaceLanguage` (`settings_screen.dart:79,329`). The Italian text is correct; only the name is left over.

## Existing tests that contradict the owner's decisions (not edited)

Root cause behind most of the 41 old failures:
- `test/support/pump_app.dart` `pumpApp(...)`: with no `locale`, no translation language is chosen, so the new non-dismissible first-launch sheet covers the app. Every tap in nearly all old widget tests then misses (warnings like "derived an Offset … would not hit test", hitting the `BottomSheet`), which leads to "Bad state: No element", "Too many elements" or "Found 0 widgets…". This affects quiz, search, settings, today, topics, my words, ads and every_screen. The harness should pre-select a translation language by default and have a separate first-launch helper. It also still calls the parameter "locale" (`settings.setLocale`), which now means the translation language.

Tests that check behaviour the owner removed:
- **Interface expected in English** (the interface is now always Italian):
  - `quiz_test.dart` "Quiz: the category list opens a twenty-question quiz" expects "Mix of all";
  - `screenshot_mode_test.dart` screens 1–4 expect "Word 1 of 10", "Question 1 of 20", "PASSED" and "Learn by category";
  - `topics_test.dart` "Topics: the grid lists the categories" expects "Learn by category";
  - `search_test.dart` "Search: nothing found shows the empty state and suggestions" expects "No word found";
  - `settings_test.dart` "the privacy screen opens and shows its text" expects "This app works offline and has no login";
  - `settings_test.dart` "a user who already paid sees the ads-removed state" expects "Ads removed. Thank you!";
  - `settings_test.dart` "the about screen shows the credits and the licences" expects "words ·";
  - any other English literals in `today_test.dart` and `ads_purchase_test.dart` ("Purchase: buying without a store shows a clear error", "Ads: Settings says setup is needed…").
- **Whole app right-to-left / interface language:**
  - `languages_test.dart` "Languages: Urdu and Shahmukhi lay the app out right to left" expects the whole app to be right-to-left for ur, pa_Arab and ar. Now only the translation text is right-to-left; the app stays Italian and left-to-right.
  - `settings_test.dart` "Settings: the interface language can be changed by hand" calls it the interface language and expects the whole app to be right-to-left after choosing Urdu.
  - `languages_test.dart` "Languages: every interface language renders the four tabs" loops over the 17 interface locales; the interface is fixed to `it`, so this is obsolete.
  - `languages_test.dart` "every locale file has every key", "placeholders are kept…" and "no translation is left as the English original" check 17 interface locales; they still pass but no longer match the product (only `it` is shown).
  - `languages_test.dart` "Languages: an unsupported phone language opens the app in English" (`AppLocales.resolve`): the app now always opens in Italian.
  - `languages_test.dart` "Languages: word translations follow the interface language" passes, but it now means the translation language; the name is outdated.
  - `every_screen_test.dart` "Every screen: the ten main languages open every tab" is still framed as interface languages, and it also hits the 320 px overflow.
- **Phone size:** `every_screen_test.dart` uses 320x600 as the small phone, while the owner's target is 360x640. Its "four tabs open with no overflow (320x600 …)" and "Settings and its sub-screens open (320x600 …)" fail on the 12 px header-pill overflow above.
- **`test/ACCEPTANCE.md` lines that no longer match the decisions:**
  - "Settings: the interface language can be changed by hand and is remembered";
  - "Settings: the app opens in the phone language and falls back to English";
  - "Languages: all seventeen interface locales have every key";
  - "Languages: Urdu and Shahmukhi render right to left" (should say: their translations render right-to-left, the app stays Italian);
  - "Languages: word translations follow the interface language" (should say: the chosen translation language);
  - missing: "the first-launch sheet asks for the translation language and cannot be skipped".

## How to run
```
flutter test test/tester1
```
Logs from this run are in the tester's scratchpad (not in the repo).
