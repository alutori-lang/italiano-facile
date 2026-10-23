import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ads_service.dart';
import '../theme.dart';
import 'banner_ad_slot.dart';

/// The one shared ad strip: the anchored adaptive banner and, under it, a
/// small link to remove the ads for an hour by watching a video.
///
/// Placed once at the bottom of the home shell (above the bottom navigation
/// bar, shared by the four tabs) and once at the bottom of the topic detail,
/// word detail and quiz result screens — never on a quiz question screen.
/// It takes no space at all when no ad may be shown.
class AdBannerArea extends StatelessWidget {
  const AdBannerArea({super.key});

  @override
  Widget build(BuildContext context) {
    final AppScope scope = AppScope.of(context);
    final bool offer =
        scope.ads.shouldShowAds && scope.ads.rewardOfferAvailable;
    return Column(
      key: const ValueKey<String>('ad-banner-area'),
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const BannerAdSlot(),
        if (offer) const _RewardLink(),
      ],
    );
  }
}

class _RewardLink extends StatelessWidget {
  const _RewardLink();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        key: const ValueKey<String>('ad-reward-link'),
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 30),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.m),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          textStyle: const TextStyle(
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
        onPressed: () => watchRewardForNoAds(context),
        child: Text(
          t.rewardNoAdsLink,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Shows the "1 hour without ads" video and tells the user, in Italian, how
/// it went. The hour is granted by [AdsService] only in onUserEarnedReward.
Future<RewardOutcome> watchRewardForNoAds(BuildContext context) async {
  final AppScope scope = AppScope.of(context);
  final AppLocalizations t = AppLocalizations.of(context);
  final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(context);
  final RewardOutcome outcome = await scope.ads.showRewardedForNoAds();
  final String message;
  switch (outcome) {
    case RewardOutcome.earned:
      message = t.rewardGranted;
    case RewardOutcome.dismissed:
      message = t.rewardNotEarned;
    case RewardOutcome.notAvailable:
      message = t.rewardNotAvailable;
  }
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        key: ValueKey<String>('reward-message-${outcome.name}'),
        content: Text(message),
      ),
    );
  return outcome;
}

/// A screen body with the shared ad strip under it: [child] takes the space
/// left, so the banner never covers a button or the end of a list.
class WithAdBanner extends StatelessWidget {
  const WithAdBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: child),
        const AdBannerArea(),
      ],
    );
  }
}
