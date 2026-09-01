import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import 'scan_animation.dart';

class ScanFrame extends StatelessWidget {
  final double size;
  final bool isScanning;

  const ScanFrame({
    Key? key,
    required this.size,
    this.isScanning = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const cornerLength = 32.0;
    const cornerWidth = 4.5;
    const borderRadius = 20.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // Top Left Corner
          Positioned(
            top: 0,
            left: 0,
            child: _buildCorner(
              isTop: true,
              isLeft: true,
              length: cornerLength,
              width: cornerWidth,
              radius: borderRadius,
            ),
          ),
          // Top Right Corner
          Positioned(
            top: 0,
            right: 0,
            child: _buildCorner(
              isTop: true,
              isLeft: false,
              length: cornerLength,
              width: cornerWidth,
              radius: borderRadius,
            ),
          ),
          // Bottom Left Corner
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildCorner(
              isTop: false,
              isLeft: true,
              length: cornerLength,
              width: cornerWidth,
              radius: borderRadius,
            ),
          ),
          // Bottom Right Corner
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCorner(
              isTop: false,
              isLeft: false,
              length: cornerLength,
              width: cornerWidth,
              radius: borderRadius,
            ),
          ),

          // Animated Scan Line
          ScanAnimation(
            width: size,
            height: size,
            isScanning: isScanning,
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({
    required bool isTop,
    required bool isLeft,
    required double length,
    required double width,
    required double radius,
  }) {
    return Container(
      width: length,
      height: length,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppColors.brightGreen, width: 4.5)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppColors.brightGreen, width: 4.5)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppColors.brightGreen, width: 4.5)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppColors.brightGreen, width: 4.5)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: (isTop && isLeft) ? Radius.circular(radius) : Radius.zero,
          topRight: (isTop && !isLeft) ? Radius.circular(radius) : Radius.zero,
          bottomLeft:
              (!isTop && isLeft) ? Radius.circular(radius) : Radius.zero,
          bottomRight:
              (!isTop && !isLeft) ? Radius.circular(radius) : Radius.zero,
        ),
      ),
    );
  }
}
