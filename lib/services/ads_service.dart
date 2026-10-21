import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/ads_config.dart';

/// AdMob, in the order Google requires:
/// 1. the UMP consent form (mandatory in the EU),
/// 2. on iOS the App Tracking Transparency prompt,
/// 3. only then MobileAds.initialize.
///
/// Nothing at all happens on the web, and nothing happens for a user who has
/// bought "remove ads".
class AdsService extends ChangeNotifier {
  AdsService();

  bool _initialized = false;
  bool _consentGathered = false;
  bool _adsAllowed = false;
  DateTime? _startedAt;
  DateTime? _lastInterstitial;
  InterstitialAd? _interstitial;
  bool _loadingInterstitial = false;

  bool get initialized => _initialized;
  bool get consentGathered => _consentGathered;

  /// True only when ads may actually be requested on this platform.
  bool get adsAllowed => _adsAllowed && !kIsWeb;

  /// Set by the purchase service: a paying user never sees an ad again.
  bool adsRemoved = false;

  bool get shouldShowAds => adsAllowed && !adsRemoved;

  /// Called when the store confirms "remove ads": drops any loaded
  /// interstitial and tells banners to disappear.
  void setAdsRemoved() {
    adsRemoved = true;
    _interstitial?.dispose();
    _interstitial = null;
    notifyListeners();
  }

  /// Called once at startup, before any ad is requested.
  Future<void> start({required bool adsRemoved}) async {
    this.adsRemoved = adsRemoved;
    _startedAt = DateTime.now();
    if (kIsWeb) {
      // On the web the app shows no ads at all.
      _consentGathered = true;
      notifyListeners();
      return;
    }
    if (adsRemoved) {
      _consentGathered = true;
      notifyListeners();
      return;
    }
    await _gatherConsent();
    // Google's rule: no ad is requested unless the consent SDK allows it.
    if (!await _canRequestAds()) return;
    await _requestTrackingOnIos();
    await _initializeMobileAds();
  }

  Future<void> _gatherConsent() async {
    try {
      final ConsentRequestParameters params = ConsentRequestParameters();
      // Each step waits for the SDK's own answer, with a timeout so a
      // consent service that never replies cannot freeze the start.
      await _requestConsentInfoUpdate(params)
          .timeout(const Duration(seconds: 10));
      await _showFormIfRequired().timeout(const Duration(minutes: 5));
    } catch (_) {
      // A consent failure must not break the app; canRequestAds below
      // decides whether ads may be requested at all.
    }
    _consentGathered = true;
    notifyListeners();
  }

  Future<void> _requestConsentInfoUpdate(ConsentRequestParameters params) {
    final Completer<void> done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () {
        if (!done.isCompleted) done.complete();
      },
      (FormError error) {
        if (!done.isCompleted) done.complete();
      },
    );
    return done.future;
  }

  Future<void> _showFormIfRequired() {
    final Completer<void> done = Completer<void>();
    ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
      if (!done.isCompleted) done.complete();
    });
    return done.future;
  }

  Future<bool> _canRequestAds() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
    } catch (_) {
      return false;
    }
  }

  /// Lets the user change their mind later, from Settings.
  Future<void> showPrivacyOptions() async {
    if (kIsWeb) return;
    try {
      ConsentForm.showPrivacyOptionsForm((FormError? error) {});
    } catch (_) {
      // The form is only available where a consent framework applies.
    }
  }

  Future<void> _requestTrackingOnIos() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (_) {
      // Older iOS versions have no prompt at all.
    }
  }

  Future<void> _initializeMobileAds() async {
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      _adsAllowed = true;
    } catch (_) {
      _initialized = false;
      _adsAllowed = false;
    }
    notifyListeners();
  }

  // ------------------------------------------------------------- banner
  /// Builds an adaptive banner for the given width, or null when no ad
  /// should be shown. The caller owns disposal.
  Future<BannerAd?> loadBanner(
    double width, {
    void Function()? onLoaded,
    void Function()? onFailed,
  }) async {
    if (!shouldShowAds) return null;
    try {
      final AdSize? size =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        width.truncate(),
      );
      final BannerAd ad = BannerAd(
        size: size ?? AdSize.banner,
        adUnitId: AdsConfig.bannerUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad _) => onLoaded?.call(),
          onAdFailedToLoad: (Ad ad, LoadAdError _) {
            ad.dispose();
            onFailed?.call();
          },
        ),
      );
      await ad.load();
      return ad;
    } catch (_) {
      onFailed?.call();
      return null;
    }
  }

  // ------------------------------------------------------- interstitial
  /// The frequency rule on its own, so it can be checked without a store:
  /// never in the first [AdsConfig.coldStartQuietMinutes] minutes after
  /// launch, and never within [AdsConfig.minMinutesBetween] minutes of the
  /// previous interstitial.
  static bool interstitialAllowedAt({
    required DateTime now,
    required DateTime startedAt,
    DateTime? lastShown,
  }) {
    if (now.difference(startedAt).inMinutes <
        AdsConfig.coldStartQuietMinutes) {
      return false;
    }
    if (lastShown != null &&
        now.difference(lastShown).inMinutes < AdsConfig.minMinutesBetween) {
      return false;
    }
    return true;
  }

  /// True when an interstitial is allowed right now.
  bool get interstitialAllowed {
    if (!shouldShowAds) return false;
    final DateTime now = DateTime.now();
    return interstitialAllowedAt(
      now: now,
      startedAt: _startedAt ?? now,
      lastShown: _lastInterstitial,
    );
  }

  Future<void> preloadInterstitial() async {
    if (!shouldShowAds || _interstitial != null || _loadingInterstitial) return;
    _loadingInterstitial = true;
    try {
      await InterstitialAd.load(
        adUnitId: AdsConfig.interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitial = ad;
            _loadingInterstitial = false;
          },
          onAdFailedToLoad: (LoadAdError _) {
            _interstitial = null;
            _loadingInterstitial = false;
          },
        ),
      );
    } catch (_) {
      _loadingInterstitial = false;
    }
  }

  /// Shows the interstitial if one is loaded and the frequency cap allows it.
  /// Returns true when an ad was actually shown.
  Future<bool> maybeShowInterstitial() async {
    if (!interstitialAllowed) return false;
    final InterstitialAd? ad = _interstitial;
    if (ad == null) {
      await preloadInterstitial();
      return false;
    }
    _interstitial = null;
    _lastInterstitial = DateTime.now();
    try {
      ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          preloadInterstitial();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError _) {
          ad.dispose();
        },
      );
      await ad.show();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _interstitial?.dispose();
    _interstitial = null;
    super.dispose();
  }
}
