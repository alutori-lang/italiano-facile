import 'package:flutter/material.dart';

import '../theme.dart';

enum MascotMood { idle, happy, sad }

/// Pomo, the app's own little tomato mascot. Drawn with plain shapes — no
/// third-party art — and animated only to react to an answer.
class Mascot extends StatefulWidget {
  const Mascot({
    super.key,
    required this.mood,
    this.size = 72,
    this.message,
  });

  final MascotMood mood;
  final double size;
  final String? message;

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void initState() {
    super.initState();
    if (widget.mood != MascotMood.idle) _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(Mascot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood && widget.mood != MascotMood.idle) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double t = Curves.easeOutBack.transform(_controller.value);
            final double lift = widget.mood == MascotMood.happy ? -10 * t : 0;
            final double tilt = widget.mood == MascotMood.sad ? 0.12 * t : 0;
            return Transform.translate(
              offset: Offset(0, lift),
              child: Transform.rotate(angle: tilt, child: child),
            );
          },
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _PomoPainter(mood: widget.mood),
            ),
          ),
        ),
        if (widget.message != null) ...<Widget>[
          const SizedBox(height: AppSpace.s),
          Text(
            widget.message!,
            textAlign: TextAlign.center,
            style: context.texts.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.ink,
            ),
          ),
        ],
      ],
    );
  }
}

class _PomoPainter extends CustomPainter {
  _PomoPainter({required this.mood});

  final MascotMood mood;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Paint body = Paint()..color = AppColors.italianRed;
    final Paint leaf = Paint()..color = const Color(0xFF3B7A57);
    final Paint face = Paint()..color = Colors.white;
    final Paint stroke = Paint()
      ..color = const Color(0xFF1C1C1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round;

    // Round tomato body.
    canvas.drawOval(
      Rect.fromLTWH(w * 0.08, h * 0.22, w * 0.84, h * 0.72),
      body,
    );

    // Three cut-paper leaves on top.
    for (final double dx in <double>[-0.17, 0.0, 0.17]) {
      final Path path = Path()
        ..moveTo(w * (0.5 + dx), h * 0.22)
        ..lineTo(w * (0.5 + dx - 0.1), h * 0.08)
        ..lineTo(w * (0.5 + dx + 0.1), h * 0.1)
        ..close();
      canvas.drawPath(path, leaf);
    }

    // Eyes.
    final double eyeY = h * 0.5;
    for (final double dx in <double>[-0.17, 0.17]) {
      canvas.drawCircle(Offset(w * (0.5 + dx), eyeY), w * 0.1, face);
      canvas.drawCircle(
        Offset(w * (0.5 + dx), eyeY + (mood == MascotMood.sad ? w * 0.02 : 0)),
        w * 0.045,
        Paint()..color = const Color(0xFF1C1C1E),
      );
    }

    // Mouth: a smile, a flat line or a frown.
    final Rect mouth = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.7),
      width: w * 0.34,
      height: h * 0.18,
    );
    switch (mood) {
      case MascotMood.happy:
        canvas.drawArc(mouth, 0.15, 2.84, false, stroke);
      case MascotMood.sad:
        canvas.drawArc(
          mouth.translate(0, h * 0.08),
          3.3,
          2.68,
          false,
          stroke,
        );
      case MascotMood.idle:
        canvas.drawLine(
          Offset(mouth.left + w * 0.04, mouth.center.dy),
          Offset(mouth.right - w * 0.04, mouth.center.dy),
          stroke,
        );
    }
  }

  @override
  bool shouldRepaint(_PomoPainter oldDelegate) => oldDelegate.mood != mood;
}
