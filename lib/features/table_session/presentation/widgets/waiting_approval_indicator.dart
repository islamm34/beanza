import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaitingApprovalIndicator extends StatefulWidget {
  final double size;
  final IconData icon;

  const WaitingApprovalIndicator({
    Key? key,
    this.size = 110,
    this.icon = Icons.local_cafe_rounded,
  }) : super(key: key);

  @override
  State<WaitingApprovalIndicator> createState() =>
      _WaitingApprovalIndicatorState();
}

class _WaitingApprovalIndicatorState extends State<WaitingApprovalIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor =
        isDark ? const Color(0xFFD0932F) : const Color(0xFFB6781E);
    final goldBright =
        isDark ? const Color(0xFFF1B447) : const Color(0xFFB6781E);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WaitingArcPainter(
              progress: _controller.value,
              trackColor: goldColor.withValues(alpha: isDark ? 0.15 : 0.10),
              glowColor: goldColor,
              highlightColor: goldBright,
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.68,
                height: widget.size * 0.68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF171A17)
                      : const Color(0xFFFFFDF8),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? goldColor : Colors.black)
                          .withValues(alpha: isDark ? 0.20 : 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: widget.size * 0.34,
                    color: goldColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WaitingArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color glowColor;
  final Color highlightColor;

  _WaitingArcPainter({
    required this.progress,
    required this.trackColor,
    required this.glowColor,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, radius, trackPaint);

    // Rotating active arc
    final startAngle = progress * 2 * math.pi;
    const sweepAngle = math.pi * 0.85;

    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          glowColor.withValues(alpha: 0.1),
          glowColor,
          highlightColor,
        ],
        stops: const [0.0, 0.7, 1.0],
        transform: GradientRotation(startAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WaitingArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
