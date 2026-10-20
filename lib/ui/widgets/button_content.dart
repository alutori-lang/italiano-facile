import 'package:flutter/material.dart';

import '../theme.dart';

/// Icon + label for a button, built so the label can never push the button
/// past the edge of the screen.
///
/// `FilledButton.icon` lays its label out at its natural width, which breaks
/// on a narrow phone or in a language whose word for "Flashcards" is three
/// times longer than the English one. Here the label is flexible and
/// shortens with an ellipsis instead.
class ButtonContent extends StatelessWidget {
  const ButtonContent({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 20),
        const SizedBox(width: AppSpace.s),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// An app-bar title that shortens instead of wrapping into the toolbar's
/// fixed height.
class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
