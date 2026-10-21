// Tester 3 — the single "remove_ads" purchase, with a fake store.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_app_651/config/monetization.dart';
import 'package:simple_flutter_app_651/screens/paywall_screen.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/purchase_service.dart';

import 't3_harness.dart';

Future<PurchaseService> newService(FakeStore store,
    {Map<String, Object> prefs = const <String, Object>{}}) async {
  SharedPreferences.resetStatic();
  SharedPreferences.setMockInitialValues(Map<String, Object>.from(prefs));
  final PurchaseService service =
      PurchaseService(await PrefsService.open(), iap: store);
  await service.init();
  return service;
}

/// Lets the broadcast stream deliver.
Future<void> flush() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Future<void> openPaywall(WidgetTester tester) async {
  await openSettings(tester);
  await tapKey(tester, 'settings-remove-ads');
  expect(find.byType(PaywallScreen), findsOneWidget);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PurchaseService with a fake store (unit)', () {
    test('init loads the real store price', () async {
      final FakeStore store = FakeStore()
        ..products = <ProductDetails>[fakeProduct(price: '3,99 €')];
      final PurchaseService s = await newService(store);
      expect(s.storeAvailable, isTrue);
      expect(s.removeAdsPrice, '3,99 €');
      expect(store.calls, contains('query:remove_ads'));
    });

    test('store unavailable: fallback price, buy -> error, no store call',
        () async {
      final FakeStore store = FakeStore()..available = false;
      final PurchaseService s = await newService(store);
      expect(s.removeAdsPrice, Monetization.removeAdsFallbackPrice);
      await s.buyRemoveAds();
      expect(s.state, PurchaseState.error);
      expect(store.calls.where((String c) => c.startsWith('buy')), isEmpty);
    });

    test('isAvailable throwing does not crash init', () async {
      final FakeStore store = FakeStore()..throwOnAvailable = true;
      final PurchaseService s = await newService(store);
      expect(s.storeAvailable, isFalse);
    });

    test('buy success: non-consumable, granted, completed, saved', () async {
      final FakeStore store = FakeStore();
      final PurchaseService s = await newService(store);
      await s.buyRemoveAds();
      expect(store.calls, contains('buyNonConsumable:remove_ads'));
      expect(store.calls.where((String c) => c.startsWith('buyConsumable')),
          isEmpty);
      expect(s.state, PurchaseState.loading);
      store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.purchased)]);
      await flush();
      expect(s.state, PurchaseState.owned);
      expect(s.adsRemoved, isTrue);
      expect(store.calls, contains('complete:purchased'));
      final SharedPreferences sp = await SharedPreferences.getInstance();
      expect(sp.getBool(PrefsService.kAdsRemoved), isTrue);
    });

    test('cancel: back to idle, nothing granted', () async {
      final FakeStore store = FakeStore();
      final PurchaseService s = await newService(store);
      await s.buyRemoveAds();
      store.emit(<PurchaseDetails>[
        fakePurchase(PurchaseStatus.canceled, pendingComplete: false),
      ]);
      await flush();
      expect(s.state, PurchaseState.idle);
      expect(s.adsRemoved, isFalse);
    });

    test('pending then purchased', () async {
      final FakeStore store = FakeStore();
      final PurchaseService s = await newService(store);
      await s.buyRemoveAds();
      store.emit(<PurchaseDetails>[
        fakePurchase(PurchaseStatus.pending, pendingComplete: false),
      ]);
      await flush();
      expect(s.state, PurchaseState.pending);
      expect(s.adsRemoved, isFalse);
      store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.purchased)]);
      await flush();
      expect(s.state, PurchaseState.owned);
      expect(s.adsRemoved, isTrue);
    });

    test('error: state error, nothing granted, transaction still completed',
        () async {
      final FakeStore store = FakeStore();
      final PurchaseService s = await newService(store);
      await s.buyRemoveAds();
      store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.error)]);
      await flush();
      expect(s.state, PurchaseState.error);
      expect(s.adsRemoved, isFalse);
      expect(store.calls, contains('complete:error'));
    });

    test('product not found -> error, no buy call', () async {
      final FakeStore store = FakeStore()..products = <ProductDetails>[];
      final PurchaseService s = await newService(store);
      await s.buyRemoveAds();
      expect(s.state, PurchaseState.error);
      expect(store.calls.where((String c) => c.startsWith('buy')), isEmpty);
    });

    test('buyNonConsumable throwing -> error', () async {
      final FakeStore store = FakeStore()..throwOnBuy = true;
      final PurchaseService s = await newService(store);
      await s.buyRemoveAds();
      expect(s.state, PurchaseState.error);
    });

    test('purchase stream error -> error state', () async {
      final FakeStore store = FakeStore();
      final PurchaseService s = await newService(store);
      store.controller.addError(Exception('store died'));
      await flush();
      expect(s.state, PurchaseState.error);
    });

    test('restore with a previous purchase (store answers at once)', () async {
      final FakeStore store = FakeStore()
        ..restoreReply = <PurchaseDetails>[fakePurchase(PurchaseStatus.restored)];
      final PurchaseService s = await newService(store);
      await s.restore();
      await flush();
      expect(s.adsRemoved, isTrue);
      expect(s.state, PurchaseState.owned);
      expect(store.calls, contains('complete:restored'));
    });

    test('restore without a previous purchase: idle, not stuck on loading',
        () async {
      final FakeStore store = FakeStore();
      final PurchaseService s = await newService(store);
      await s.restore();
      await flush();
      expect(s.adsRemoved, isFalse);
      expect(s.state, PurchaseState.idle);
    });

    test('restore failing -> error, not granted', () async {
      final FakeStore store = FakeStore()..throwOnRestore = true;
      final PurchaseService s = await newService(store);
      await s.restore();
      await flush();
      expect(s.adsRemoved, isFalse);
      expect(s.state, PurchaseState.error);
    });

    test(
        'KNOWN GAP (documents behaviour): a refunded / revoked purchase is '
        'never taken back — once saved, adsRemoved stays true even when the '
        'store no longer returns the purchase', () async {
      final FakeStore store = FakeStore();
      final PurchaseService s = await newService(
        store,
        prefs: const <String, Object>{PrefsService.kAdsRemoved: true},
      );
      await s.restore();
      await flush();
      // There is no revocation path in purchase_service.dart.
      expect(s.adsRemoved, isTrue);
    });

    test('iOS uses the account-unique product id', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        final FakeStore store = FakeStore();
        await newService(store);
        expect(store.calls, contains('query:simple_flutter_app_651_remove_ads'));
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });

  group('Paywall + Settings with a fake store (widget)', () {
    testWidgets('paywall shows the store price on the buy button',
        (WidgetTester tester) async {
      await pumpT3App(tester);
      await openPaywall(tester);
      expect(find.text('${it.buy} · 3,99 €'), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('paywall-restore')),
          findsOneWidget);
    });

    testWidgets('buy -> purchased: paywall shows "ads removed", settings row too',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-buy');
      expect(app.store.calls, contains('buyNonConsumable:remove_ads'));
      app.store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.purchased)]);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('paywall-buy')), findsNothing);
      expect(find.text(it.adsRemoved), findsOneWidget);
      await goBack(tester);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('settings-remove-ads')),
          matching: find.text(it.adsRemoved),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'buy -> purchased later through the stream: AdsService learns about it '
        '(ads.adsRemoved must become true in the same session)',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-buy');
      app.store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.purchased)]);
      await tester.pumpAndSettle();
      expect(app.purchases.adsRemoved, isTrue);
      expect(
        app.ads.adsRemoved,
        isTrue,
        reason: 'paywall_screen.dart _buy copies purchases.adsRemoved into '
            'ads.adsRemoved right after buyRemoveAds() returns, i.e. BEFORE '
            'the store answers; nothing copies it again when the purchase '
            'arrives on the stream, so banner + interstitial keep showing '
            'until the app is restarted',
      );
    });

    testWidgets('cancel: buy button is enabled again, no message of success',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-buy');
      final FilledButton busy = tester.widget(
        find.byKey(const ValueKey<String>('paywall-buy')),
      );
      expect(busy.onPressed, isNull, reason: 'disabled while loading');
      app.store.emit(<PurchaseDetails>[
        fakePurchase(PurchaseStatus.canceled, pendingComplete: false),
      ]);
      await tester.pumpAndSettle();
      final FilledButton again = tester.widget(
        find.byKey(const ValueKey<String>('paywall-buy')),
      );
      expect(again.onPressed, isNotNull);
      expect(find.text(it.adsRemoved), findsNothing);
      expect(find.text(it.purchaseError), findsNothing);
    });

    testWidgets('pending shows the pending note, then purchased',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-buy');
      app.store.emit(<PurchaseDetails>[
        fakePurchase(PurchaseStatus.pending, pendingComplete: false),
      ]);
      await tester.pumpAndSettle();
      expect(find.text(it.purchasePending), findsOneWidget);
      app.store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.purchased)]);
      await tester.pumpAndSettle();
      expect(find.text(it.purchasePending), findsNothing);
      expect(find.text(it.adsRemoved), findsOneWidget);
    });

    testWidgets('error shows the purchase error and the button works again',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-buy');
      app.store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.error)]);
      await tester.pumpAndSettle();
      expect(find.text(it.purchaseError), findsOneWidget);
      final FilledButton again = tester.widget(
        find.byKey(const ValueKey<String>('paywall-buy')),
      );
      expect(again.onPressed, isNotNull);
    });

    testWidgets('store unavailable shows the store-unavailable message',
        (WidgetTester tester) async {
      final FakeStore store = FakeStore()..available = false;
      await pumpT3App(tester, store: store);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-buy');
      expect(find.text(it.storeUnavailable), findsOneWidget);
    });

    testWidgets('restore with nothing bought says so; buy stays enabled',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-restore');
      expect(app.store.calls, contains('restore'));
      expect(find.text(it.nothingToRestore), findsOneWidget);
      final FilledButton buy = tester.widget(
        find.byKey(const ValueKey<String>('paywall-buy')),
      );
      expect(buy.onPressed, isNotNull);
    });

    testWidgets('restore from Settings with a previous purchase (fast store)',
        (WidgetTester tester) async {
      final FakeStore store = FakeStore()
        ..restoreReply = <PurchaseDetails>[fakePurchase(PurchaseStatus.restored)];
      final T3App app = await pumpT3App(tester, store: store);
      await openSettings(tester);
      await tapKey(tester, 'settings-restore');
      expect(app.purchases.adsRemoved, isTrue);
      expect(app.ads.adsRemoved, isTrue);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('settings-status')),
          matching: find.text(it.adsRemoved),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'restore with a previous purchase from a REAL-speed store (answers '
        'after 800 ms): the paywall ends on "ads removed" and AdsService '
        'stops ads in this session', (WidgetTester tester) async {
      final FakeStore store = FakeStore()
        ..restoreReply = <PurchaseDetails>[fakePurchase(PurchaseStatus.restored)]
        ..restoreDelay = const Duration(milliseconds: 800);
      final T3App app = await pumpT3App(tester, store: store);
      await openPaywall(tester);
      await tapKey(tester, 'paywall-restore');
      // Before the store answers the page shows the hedged "request sent".
      expect(find.byKey(const ValueKey<String>('paywall-status')),
          findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(app.purchases.adsRemoved, isTrue);
      expect(find.byKey(const ValueKey<String>('paywall-buy')), findsNothing);
      expect(
        app.ads.adsRemoved,
        isTrue,
        reason: 'paywall_screen.dart _restore copies purchases.adsRemoved into '
            'ads.adsRemoved before the store has answered; the message says '
            '"la pubblicita sparisce tra pochi secondi" but banner and '
            'interstitial stay until the app is restarted',
      );
    });
  });
}
