import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'ads_service.dart';

import '../config/monetization.dart';
import 'prefs_service.dart';

enum PurchaseState { idle, loading, pending, owned, error }

/// The single purchase in the app: remove ads, once, forever.
///
/// The entitlement is stored locally so it survives a restart and works
/// offline; "Restore purchases" asks the store again.
class PurchaseService extends ChangeNotifier {
  PurchaseService(this._prefs, {InAppPurchase? iap}) : _injected = iap;

  final PrefsService _prefs;
  final InAppPurchase? _injected;

  /// Resolved lazily: touching InAppPurchase.instance registers the store
  /// plugin, which must not happen until the app actually needs it (and never
  /// in a widget test, where no store exists).
  InAppPurchase get _iap => _injected ?? InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  PurchaseState _state = PurchaseState.idle;
  String? _price;
  bool _storeAvailable = false;

  PurchaseState get state => _state;

  /// The real store price once loaded; otherwise the fallback label.
  String get removeAdsPrice => _price ?? Monetization.removeAdsFallbackPrice;

  bool get storeAvailable => _storeAvailable;

  bool get adsRemoved => _prefs.getBool(PrefsService.kAdsRemoved);

  /// Purchases are not available in a browser.
  bool get supportedOnThisPlatform => !kIsWeb;

  Future<void> init() async {
    if (!supportedOnThisPlatform) {
      _state = PurchaseState.idle;
      notifyListeners();
      return;
    }
    try {
      _subscription =
          _iap.purchaseStream.listen(_onPurchaseUpdate, onError: (Object _) {
        _state = PurchaseState.error;
        notifyListeners();
      });
      _storeAvailable = await _iap.isAvailable();
    } catch (_) {
      _storeAvailable = false;
    }
    if (_storeAvailable) await _loadProduct();
    notifyListeners();
  }

  Future<void> _loadProduct() async {
    try {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(Monetization.productIds);
      if (response.productDetails.isNotEmpty) {
        _price = response.productDetails.first.price;
      }
    } catch (_) {
      // Keep the fallback price; the button still works.
    }
    notifyListeners();
  }

  Future<void> buyRemoveAds() async {
    if (!supportedOnThisPlatform || !_storeAvailable) {
      _state = PurchaseState.error;
      notifyListeners();
      return;
    }
    _state = PurchaseState.loading;
    notifyListeners();
    try {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(Monetization.productIds);
      if (response.productDetails.isEmpty) {
        _state = PurchaseState.error;
        notifyListeners();
        return;
      }
      await _iap.buyNonConsumable(
        purchaseParam:
            PurchaseParam(productDetails: response.productDetails.first),
      );
    } catch (_) {
      _state = PurchaseState.error;
      notifyListeners();
    }
  }

  AdsService? _linkedAds;

  /// Keeps [ads] in step with the purchase: a purchase or restore confirmed
  /// later by the store hides the ads at once, not only after a restart.
  /// Safe to call more than once.
  void linkAds(AdsService ads) {
    if (identical(_linkedAds, ads)) return;
    _linkedAds = ads;
    void sync() {
      if (adsRemoved && !ads.adsRemoved) ads.setAdsRemoved();
    }
    addListener(sync);
    sync();
  }

  Future<void> restore() async {
    if (!supportedOnThisPlatform) return;
    _state = PurchaseState.loading;
    notifyListeners();
    // The request is sent without waiting on it: the store answers through
    // the purchase stream (which sets the state to "owned" when an earlier
    // purchase comes back), and a store that never replies must not leave
    // the app stuck on "loading" with the Buy button disabled.
    unawaited(_iap.restorePurchases().catchError((Object _) {
      _state = PurchaseState.error;
      notifyListeners();
    }));
    await Future<void>.delayed(Duration.zero);
    if (!adsRemoved && _state == PurchaseState.loading) {
      _state = PurchaseState.idle;
      notifyListeners();
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _state = PurchaseState.pending;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _grant();
          _state = PurchaseState.owned;
        case PurchaseStatus.error:
          _state = PurchaseState.error;
        case PurchaseStatus.canceled:
          _state = PurchaseState.idle;
      }
      if (purchase.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(purchase);
        } catch (_) {
          // Completion is retried by the store on the next launch.
        }
      }
      notifyListeners();
    }
  }

  Future<void> _grant() async {
    await _prefs.setBool(PrefsService.kAdsRemoved, true);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
