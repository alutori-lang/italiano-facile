import 'package:flutter/material.dart';

import '../theme.dart';

/// The header used at the top of every tab: a big title, a quiet subtitle and
/// an optional pill on the end side.
///
/// The title and the pill share the width in fixed proportions. Without that,
/// a long pill label ("0 dias seguidos") squeezes the title into a sliver and
/// the title wraps one letter per line, which on a small phone pushes the
/// whole screen past its bottom edge.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpace.s,
        bottom: AppSpace.l,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.headlineMedium,
                ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: AppSpace.m),
            Flexible(flex: 2, child: trailing!),
          ],
        ],
      ),
    );
  }
}

/// A small rounded pill, used for the language shortcut and the streak.
class HeaderPill extends StatelessWidget {
  const HeaderPill({
    super.key,
    required this.label,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Material(
        color: context.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          side: BorderSide(color: context.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.m,
              vertical: AppSpace.s + 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 18, color: iconColor ?? context.ink),
                  const SizedBox(width: AppSpace.xs + 2),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.ink,
                    ),
                  ),
                ),
                if (onTap != null) ...<Widget>[
                  const SizedBox(width: AppSpace.xs),
                  Icon(
                    Icons.expand_more_rounded,
                    size: 16,
                    color: context.muted,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
