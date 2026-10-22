import 'package:flutter/material.dart';

import '../theme.dart';

/// A rectangle edged with the Italian flag: green, white and red bands side
/// by side. Used around the search box, where the user types.
class TricolourFrame extends StatelessWidget {
  const TricolourFrame({
    super.key,
    required this.child,
    this.radius = 18,
    this.thickness = 4,
  });

  final Widget child;
  final double radius;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final List<Color> c = AppColors.tricolour;
    return DecoratedBox(
      key: const ValueKey<String>('tricolour-frame'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: <Color>[c[0], c[0], c[1], c[1], c[2], c[2]],
          stops: const <double>[0, 1 / 3, 1 / 3, 2 / 3, 2 / 3, 1],
        ),
        // A hairline so the white band still reads on a white page.
        border: Border.all(color: context.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(thickness),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - thickness),
          child: child,
        ),
      ),
    );
  }
}

/// The app logo ("Ciao!" over the flag), shown beside each tab's title.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      key: const ValueKey<String>('app-logo'),
      width: size,
      height: size,
      semanticLabel: 'Italiano Facile',
    );
  }
}
