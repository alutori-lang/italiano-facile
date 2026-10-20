import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../app_scope.dart';

/// One adaptive banner, shown only at the bottom of Topics and of the quiz
/// result screen. It renders nothing on the web, nothing before consent, and
/// nothing for a user who bought "remove ads". A failed load retries once.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _ad;
  bool _loaded = false;
  int _attempts = 0;
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AppScope scope = AppScope.of(context);
    if (!scope.ads.shouldShowAds) {
      // Either consent is still being gathered, or the user has paid. Drop any
      // ad we hold and stay ready to try again when that changes.
      if (_ad != null) {
        _ad!.dispose();
        _ad = null;
        _loaded = false;
      }
      _requested = false;
      return;
    }
    if (!_requested) {
      _requested = true;
      _load();
    }
  }

  Future<void> _load() async {
    final AppScope scope = AppScope.of(context);
    if (!scope.ads.shouldShowAds) return;
    final double width = MediaQuery.sizeOf(context).width;
    final BannerAd? ad = await scope.ads.loadBanner(
      width,
      onLoaded: () {
        if (mounted) setState(() => _loaded = true);
      },
      onFailed: () {
        if (!mounted) return;
        setState(() {
          _ad = null;
          _loaded = false;
        });
        if (_attempts < 1) {
          _attempts++;
          _load();
        }
      },
    );
    if (!mounted) {
      ad?.dispose();
      return;
    }
    setState(() => _ad = ad);
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerAd? ad = _ad;
    if (ad == null || !_loaded) return const SizedBox.shrink();
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
