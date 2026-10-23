import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/ads_config.dart';
import 'prefs_service.dart';

/// How a "1 hour without ads" video ended.
enum RewardOutcome {
  /// The user watched it: no ads for one hour.
  earned,

  /// The video was closed before the reward.
  dismissed,

  /// No video was ready (or it failed to show).
  notAvailable,
}

/// AdMob, in the order Google requires:
/// 1. the UMP consent form (mandatory in the EU),
/// 2. on iOS the App Tracking Transparency prompt,
/// 3. only then MobileAds.initialize — and only if UMP's canRequestAds says
///    ads may be requested at all.
///
/// Formats: one anchored adaptive banner, interstitials after a finished
/// quiz or flashcard deck, an app open ad on some cold starts, and a
/// rewarded video that removes every ad for one hour.
///
/// Nothing at all happens on the web, and nothing happens for a user who has
/// bought "remove ads".
class AdsService extends ChangeNotifier {
  AdsService({PrefsService? prefs, DateTime Function()? clock})
      : _prefs = prefs,
        _clock = clock ?? DateTime.now {
    _restoreReward();
  }

  final PrefsService? _prefs;
  final DateTime Function() _clock;

  bool _initialized = false;
  bool _consentGathered = false;
  bool _adsAllowed = false;
  DateTime? _startedAt;
  DateTime? _lastInterstitial;
  InterstitialAd? _interstitial;
  bool _loadingInterstitial = false;

  /// A full-screen ad (interstitial, rewarded, app open) is on screen.
  bool _fullScreenShowing = false;

  /// When the last full-screen ad was shown or closed.
  DateTime? _lastFullScreenAt;

  bool get initialized => _initialized;
  bool get consentGathered => _consentGathered;

  /// True only when ads may actually be requested on this platform.
  bool get adsAllowed => _adsAllowed && !kIsWeb;

  /// Set by the purchase service: a paying user never sees an ad again.
  bool adsRemoved = false;

  /// Banners, interstitials and app open ads may be shown right now: ads are
  /// allowed, the user has not paid, and no "1 hour without ads" is running.
  bool get shouldShowAds => adsAllowed && !adsRemoved && !rewardActive;

  /// Called when the store confirms "remove ads": drops every loaded ad and
  /// tells banners to disappear.
  void setAdsRemoved() {
    adsRemoved = true;
    _interstitial?.dispose();
    _interstitial = null;
    _rewarded?.dispose();
    _rewarded = null;
    _appOpen?.dispose();
    _appOpen = null;
    notifyListeners();
  }

  /// Called once at startup, before any ad is requested.
  Future<void> start({required bool adsRemoved}) async {
    this.adsRemoved = adsRemoved;
    _startedAt = _clock();
    await _countLaunch();
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

  Future<void> _countLaunch() async {
    final PrefsService? prefs = _prefs;
    if (prefs == null) return;
    try {
      await prefs.setInt(
        PrefsService.kAdsLaunches,
        prefs.getInt(PrefsService.kAdsLaunches) + 1,
      );
    } catch (_) {
      // Counting launches must never break the start.
    }
  }

  /// How many times the app has been started, this launch included. 0 when
  /// nothing is stored (then the app open ad treats it as a first launch).
  int get launchCount => _prefs?.getInt(PrefsService.kAdsLaunches) ?? 0;

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

  void _fullScreenStarted() {
    _fullScreenShowing = true;
    _lastFullScreenAt = _clock();
  }

  void _fullScreenEnded() {
    _fullScreenShowing = false;
    _lastFullScreenAt = _clock();
  }

  // ------------------------------------------------------------- banner
  /// Builds an anchored adaptive banner for the given width, or null when no
  /// ad should be shown. The caller owns disposal.
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
  /// previous interstitial. One cap shared by quizzes and flashcard decks.
  static bool interstitialAllowedAt({
    required DateTime now,
    required DateTime startedAt,
    DateTime? lastShown,
  }) {
    if (now.difference(startedAt).inMinutes < AdsConfig.coldStartQuietMinutes) {
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
    if (!shouldShowAds || _fullScreenShowing) return false;
    final DateTime now = _clock();
    return interstitialAllowedAt(
      now: now,
      startedAt: _startedAt ?? now,
      lastShown: _lastInterstitial,
    );
  }

  Future<void> preloadInterstitial() async {
    if (!adsAllowed || adsRemoved) return;
    if (_interstitial != null || _loadingInterstitial) return;
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
  /// Returns true when an ad was actually shown. Used after a finished quiz
  /// and after a finished flashcard deck.
  Future<bool> maybeShowInterstitial() async {
    if (!interstitialAllowed) return false;
    final InterstitialAd? ad = _interstitial;
    if (ad == null) {
      await preloadInterstitial();
      return false;
    }
    _interstitial = null;
    _lastInterstitial = _clock();
    try {
      ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
        onAdShowedFullScreenContent: (InterstitialAd _) => _fullScreenStarted(),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _fullScreenEnded();
          preloadInterstitial();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError _) {
          ad.dispose();
          _fullScreenEnded();
        },
      );
      _fullScreenStarted();
      await ad.show();
      return true;
    } catch (_) {
      _fullScreenEnded();
      return false;
    }
  }

  // ----------------------------------------------------------- app open
  AppOpenAd? _appOpen;
  DateTime? _appOpenLoadedAt;
  Completer<void>? _appOpenLoading;
  bool _coldStartHandled = false;

  /// The app open rule on its own:
  /// - never in the very first session (a new user picks a language first),
  /// - never while, or just after, another full-screen ad,
  /// - at most once every [AdsConfig.appOpenMinGap].
  static bool appOpenAllowedAt({
    required DateTime now,
    required int launchCount,
    DateTime? lastShown,
    DateTime? lastFullScreen,
    bool fullScreenShowing = false,
    bool firstLaunchUi = false,
  }) {
    if (launchCount <= 1 || firstLaunchUi) return false;
    if (fullScreenShowing) return false;
    if (lastFullScreen != null) {
      final Duration since = now.difference(lastFullScreen);
      if (since < AdsConfig.afterFullScreenQuiet) return false;
    }
    if (lastShown != null) {
      final Duration since = now.difference(lastShown);
      // A clock moved backwards by less than the gap counts as "too soon".
      if (since < AdsConfig.appOpenMinGap && since > -AdsConfig.appOpenMinGap) {
        return false;
      }
    }
    return true;
  }

  /// A preloaded app open ad is only used while it is fresh.
  static bool appOpenAdFresh({
    required DateTime loadedAt,
    required DateTime now,
  }) {
    final Duration age = now.difference(loadedAt);
    return !age.isNegative && age < AdsConfig.appOpenAdExpiry;
  }

  DateTime? get lastAppOpenShown {
    final int ms = _prefs?.getInt(PrefsService.kAppOpenLast) ?? 0;
    return ms == 0 ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  bool _appOpenAllowedNow({bool firstLaunchUi = false}) {
    if (!shouldShowAds) return false;
    return appOpenAllowedAt(
      now: _clock(),
      launchCount: launchCount,
      lastShown: lastAppOpenShown,
      lastFullScreen: _lastFullScreenAt,
      fullScreenShowing: _fullScreenShowing,
      firstLaunchUi: firstLaunchUi,
    );
  }

  /// Loads an app open ad unless a fresh one is already there; a stale one
  /// (older than [AdsConfig.appOpenAdExpiry]) is dropped and replaced.
  Future<void> preloadAppOpen() {
    if (!adsAllowed || adsRemoved) return Future<void>.value();
    final AppOpenAd? current = _appOpen;
    final DateTime? loadedAt = _appOpenLoadedAt;
    if (current != null && loadedAt != null) {
      if (appOpenAdFresh(loadedAt: loadedAt, now: _clock())) {
        return Future<void>.value();
      }
      current.dispose();
      _appOpen = null;
      _appOpenLoadedAt = null;
    }
    final Completer<void>? loading = _appOpenLoading;
    if (loading != null && !loading.isCompleted) return loading.future;
    final Completer<void> done = Completer<void>();
    _appOpenLoading = done;
    void finish() {
      if (!done.isCompleted) done.complete();
    }

    AppOpenAd.load(
      adUnitId: AdsConfig.appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) {
          _appOpen = ad;
          _appOpenLoadedAt = _clock();
          finish();
        },
        onAdFailedToLoad: (LoadAdError _) => finish(),
      ),
    ).catchError((Object _) => finish());
    return done.future;
  }

  /// Called once, on a cold start, after consent and MobileAds.initialize.
  /// Shows an app open ad when every rule allows it. [firstLaunchUi] is true
  /// while the first-launch language picker is needed. Returns true when an
  /// ad was shown.
  Future<bool> showAppOpenOnColdStart({bool firstLaunchUi = false}) async {
    if (_coldStartHandled) return false;
    _coldStartHandled = true;
    if (!_appOpenAllowedNow(firstLaunchUi: firstLaunchUi)) return false;
    try {
      await preloadAppOpen().timeout(AdsConfig.appOpenLoadTimeout);
    } catch (_) {
      return false;
    }
    final AppOpenAd? ad = _appOpen;
    final DateTime? loadedAt = _appOpenLoadedAt;
    if (ad == null ||
        loadedAt == null ||
        !appOpenAdFresh(loadedAt: loadedAt, now: _clock())) {
      return false;
    }
    // Checked again: an interstitial or a purchase may have happened while
    // the ad was loading.
    if (!_appOpenAllowedNow(firstLaunchUi: firstLaunchUi)) return false;
    _appOpen = null;
    _appOpenLoadedAt = null;
    try {
      await _prefs?.setInt(
        PrefsService.kAppOpenLast,
        _clock().millisecondsSinceEpoch,
      );
      ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
        onAdShowedFullScreenContent: (AppOpenAd _) => _fullScreenStarted(),
        onAdDismissedFullScreenContent: (AppOpenAd ad) {
          ad.dispose();
          _fullScreenEnded();
        },
        onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError _) {
          ad.dispose();
          _fullScreenEnded();
        },
      );
      _fullScreenStarted();
      await ad.show();
      return true;
    } catch (_) {
      _fullScreenEnded();
      return false;
    }
  }

  // ----------------------------------------------- rewarded: 1 h no ads
  RewardedAd? _rewarded;
  bool _loadingRewarded = false;
  DateTime? _noAdsUntil;
  Timer? _rewardTimer;

  void _restoreReward() {
    final int ms = _prefs?.getInt(PrefsService.kNoAdsUntil) ?? 0;
    if (ms == 0) return;
    final DateTime until = DateTime.fromMillisecondsSinceEpoch(ms);
    // A stored end further away than one reward is a changed clock: ignore.
    final Duration left = until.difference(_clock());
    if (left > AdsConfig.rewardNoAdsDuration) return;
    _noAdsUntil = until;
    _scheduleRewardEnd();
  }

  /// When the current "1 hour without ads" ends, or null.
  DateTime? get noAdsUntil => rewardActive ? _noAdsUntil : null;

  /// True while a "1 hour without ads" reward is running.
  bool get rewardActive {
    final DateTime? until = _noAdsUntil;
    return until != null && _clock().isBefore(until);
  }

  /// Time left without ads, or [Duration.zero].
  Duration get noAdsRemaining {
    final DateTime? until = _noAdsUntil;
    if (until == null) return Duration.zero;
    final Duration left = until.difference(_clock());
    return left.isNegative ? Duration.zero : left;
  }

  /// The "1 hour without ads" video may be offered: ads are allowed, the
  /// user has not bought remove_ads and no reward is already running.
  bool get rewardOfferAvailable => adsAllowed && !adsRemoved && !rewardActive;

  void _scheduleRewardEnd() {
    _rewardTimer?.cancel();
    final Duration left = noAdsRemaining;
    if (left == Duration.zero) return;
    _rewardTimer = Timer(left + const Duration(seconds: 1), () {
      _rewardTimer = null;
      notifyListeners();
      preloadRewarded();
    });
  }

  /// Grants the reward. Called ONLY from the rewarded ad's
  /// onUserEarnedReward callback (and by tests that stand in for it).
  @visibleForTesting
  Future<void> handleUserEarnedReward() async {
    final DateTime until = _clock().add(AdsConfig.rewardNoAdsDuration);
    _noAdsUntil = until;
    _scheduleRewardEnd();
    notifyListeners();
    try {
      await _prefs?.setInt(
        PrefsService.kNoAdsUntil,
        until.millisecondsSinceEpoch,
      );
    } catch (_) {
      // The reward still holds for this session.
    }
  }

  /// Loads the video in advance (a loaded rewarded ad lasts about an hour,
  /// so nothing is loaded while a reward is already running).
  Future<void> preloadRewarded() async {
    if (!rewardOfferAvailable) return;
    if (_rewarded != null || _loadingRewarded) return;
    _loadingRewarded = true;
    try {
      await RewardedAd.load(
        adUnitId: AdsConfig.rewardedUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewarded = ad;
            _loadingRewarded = false;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError _) {
            _rewarded = null;
            _loadingRewarded = false;
          },
        ),
      );
    } catch (_) {
      _loadingRewarded = false;
    }
  }

  /// Shows the "1 hour without ads" video. The hour is granted only when the
  /// SDK reports that the user earned the reward.
  Future<RewardOutcome> showRewardedForNoAds() async {
    if (!rewardOfferAvailable) return RewardOutcome.notAvailable;
    final RewardedAd? ad = _rewarded;
    if (ad == null) {
      unawaited(preloadRewarded());
      return RewardOutcome.notAvailable;
    }
    _rewarded = null;
    final Completer<RewardOutcome> done = Completer<RewardOutcome>();
    bool earned = false;
    void finish(RewardOutcome outcome) {
      if (!done.isCompleted) done.complete(outcome);
    }

    try {
      ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
        onAdShowedFullScreenContent: (RewardedAd _) => _fullScreenStarted(),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _fullScreenEnded();
          finish(earned ? RewardOutcome.earned : RewardOutcome.dismissed);
          if (!earned) preloadRewarded();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError _) {
          ad.dispose();
          _fullScreenEnded();
          finish(RewardOutcome.notAvailable);
          preloadRewarded();
        },
      );
      _fullScreenStarted();
      await ad.show(
        onUserEarnedReward: (AdWithoutView _, RewardItem __) {
          earned = true;
          handleUserEarnedReward();
        },
      );
    } catch (_) {
      _fullScreenEnded();
      finish(RewardOutcome.notAvailable);
    }
    return done.future;
  }

  @override
  void dispose() {
    _rewardTimer?.cancel();
    _rewardTimer = null;
    _interstitial?.dispose();
    _interstitial = null;
    _rewarded?.dispose();
    _rewarded = null;
    _appOpen?.dispose();
    _appOpen = null;
    super.dispose();
  }
}
