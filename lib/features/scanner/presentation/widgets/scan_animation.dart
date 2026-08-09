import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ScanAnimation extends StatefulWidget {
  final double width;
  final double height;
  final bool isScanning;

  const ScanAnimation({
    Key? key,
    required this.width,
    required this.height,
    this.isScanning = true,
  }) : super(key: key);

  @override
  State<ScanAnimation> createState() => _ScanAnimationState();
}

class _ScanAnimationState extends State<ScanAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isScanning) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ScanAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning != oldWidget.isScanning) {
      if (widget.isScanning) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isScanning) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final topOffset = _animation.value * (widget.height - 4);
        return Positioned(
          top: topOffset,
          left: 8,
          right: 8,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.caramel.withOpacity(0.1),
                  AppColors.caramel,
                  AppColors.caramel.withOpacity(0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.caramel.withOpacity(0.8),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
