import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  final double scanBoxSize;
  final double borderRadius;

  const ScannerOverlay({
    Key? key,
    required this.scanBoxSize,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScannerOverlayPainter(
        scanBoxSize: scanBoxSize,
        borderRadius: borderRadius,
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double scanBoxSize;
  final double borderRadius;

  _ScannerOverlayPainter({
    required this.scanBoxSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final scanBoxRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanBoxSize,
      height: scanBoxSize,
    );

    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanBoxRect, Radius.circular(borderRadius)));

    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.65)
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanBoxSize != scanBoxSize ||
        oldDelegate.borderRadius != borderRadius;
  }
}
