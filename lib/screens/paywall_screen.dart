import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../services/purchase_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';

/// The one purchase in the app. Everything else stays free.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  /// Result of the last restore, shown in the page rather than as a toast
  /// that disappears on its own.
  String? _status;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final AppScope scope = AppScope.of(context);
    final PurchaseService purchases = scope.purchases;
    final bool owned = purchases.adsRemoved;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(t.removeAds)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.xl),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(AppSpace.xl),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: context.border),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.italianRed.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadii.box),
                    ),
                    child: const Icon(
                      Icons.block_rounded,
                      size: 34,
                      color: AppColors.italianRed,
                    ),
                  ),
                  const SizedBox(height: AppSpace.l),
                  Text(
                    t.removeAds,
                    textAlign: TextAlign.center,
                    style: context.texts.titleLarge,
                  ),
                  const SizedBox(height: AppSpace.s),
                  Text(
                    t.removeAdsBody,
                    textAlign: TextAlign.center,
                    style: context.texts.bodyMedium,
                  ),
                  const SizedBox(height: AppSpace.l),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      purchases.removeAdsPrice,
                      style: context.texts.displaySmall?.copyWith(
                        color: context.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            if (!purchases.supportedOnThisPlatform)
              Text(
                t.webPurchaseNotice,
                textAlign: TextAlign.center,
                style: context.texts.bodyMedium,
              )
            else if (owned)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.correct,
                  ),
                  const SizedBox(width: AppSpace.s),
                  Flexible(
                    child: Text(
                      t.adsRemoved,
                      style: context.texts.titleMedium,
                    ),
                  ),
                ],
              )
            else ...<Widget>[
              FilledButton(
                key: const ValueKey<String>('paywall-buy'),
                onPressed: purchases.state == PurchaseState.loading
                    ? null
                    : () => _buy(context),
                child: ButtonContent(
                  icon: Icons.shopping_bag_rounded,
                  label: '${t.buy} · ${purchases.removeAdsPrice}',
                ),
              ),
              const SizedBox(height: AppSpace.m),
              OutlinedButton(
                key: const ValueKey<String>('paywall-restore'),
                onPressed: () => _restore(context),
                child: ButtonContent(
                  icon: Icons.restore_rounded,
                  label: t.restorePurchases,
                ),
              ),
            ],
            if (purchases.state == PurchaseState.pending) ...<Widget>[
              const SizedBox(height: AppSpace.l),
              Text(
                t.purchasePending,
                textAlign: TextAlign.center,
                style: context.texts.bodySmall,
              ),
            ],
            if (_status != null) ...<Widget>[
              const SizedBox(height: AppSpace.l),
              Text(
                _status!,
                key: const ValueKey<String>('paywall-status'),
                textAlign: TextAlign.center,
                style: context.texts.bodyMedium,
              ),
            ],
            if (purchases.state == PurchaseState.error) ...<Widget>[
              const SizedBox(height: AppSpace.l),
              Text(
                purchases.storeAvailable
                    ? t.purchaseError
                    : t.storeUnavailable,
                textAlign: TextAlign.center,
                style: context.texts.bodySmall?.copyWith(
                  color: AppColors.wrong,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _buy(BuildContext context) async {
    final AppScope scope = AppScope.of(context);
    await scope.purchases.buyRemoveAds();
    scope.ads.adsRemoved = scope.purchases.adsRemoved;
  }

  Future<void> _restore(BuildContext context) async {
    final AppScope scope = AppScope.of(context);
    final AppLocalizations t = AppLocalizations.of(context);
    await scope.purchases.restore();
    scope.ads.adsRemoved = scope.purchases.adsRemoved;
    if (!mounted) return;
    setState(() {
      _status =
          scope.purchases.adsRemoved ? t.adsRemoved : t.nothingToRestore;
    });
  }
}
