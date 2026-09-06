import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// An adaptive cafe logo widget that responds to application theme brightness changes.
///
/// In Light Mode: displays a subtle warm shadow matching the brown-and-gold branding.
/// In Dark Mode: places the logo on a subtle translucent warm-gold/surface glow so
/// dark details remain clear.
class AdaptiveCafeLogo extends StatelessWidget {
  final double size;
  final String semanticsLabel;
  final EdgeInsetsGeometry? padding;

  const AdaptiveCafeLogo({
    Key? key,
    this.size = 160,
    this.semanticsLabel = 'Cafe logo',
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? const Color(0xFFD4AF37).withValues(alpha: 0.16)
                : const Color(0xFF5D2F1A).withValues(alpha: 0.14),
            blurRadius: isDarkMode ? 24 : 18,
            spreadRadius: isDarkMode ? 2 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SvgPicture.asset(
        'assets/premium_cafe_3d_logo.svg',
        fit: BoxFit.contain,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}

/// Helper function to build an adaptive cafe logo.
Widget buildAdaptiveCafeLogo({
  required BuildContext context,
  double size = 160,
  String semanticsLabel = 'Cafe logo',
  EdgeInsetsGeometry? padding,
}) {
  return AdaptiveCafeLogo(
    size: size,
    semanticsLabel: semanticsLabel,
    padding: padding,
  );
}
