import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/favorites_controller.dart';
import '../../../app/theme/app_colors.dart';

/// A reusable reactive Favorite heart button that connects directly to [FavoritesController]
/// and updates instantly across the entire application without rebuilding full parent trees.
class FavoriteButton extends StatelessWidget {
  final String productId;
  final double size;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showBackground;
  final VoidCallback? onTapped;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.size = 32,
    this.iconSize = 18,
    this.padding,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.showBackground = true,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final controller = Get.isRegistered<FavoritesController>()
        ? Get.find<FavoritesController>()
        : Get.put(FavoritesController());

    return Obx(() {
      final isFav = controller.isFavorite(productId);

      final effectiveActiveColor = activeColor ?? AppColors.error;
      final effectiveInactiveColor = inactiveColor ??
          (isDark
              ? Colors.white70
              : AppColors.espressoDark.withValues(alpha: 0.60));

      final effectiveBgColor = backgroundColor ??
          (isDark
              ? Colors.black.withValues(alpha: 0.65)
              : Colors.white.withValues(alpha: 0.88));

      final iconWidget = AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        ),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey<bool>(isFav),
          size: iconSize,
          color: isFav ? effectiveActiveColor : effectiveInactiveColor,
        ),
      );

      final label = isFav ? 'Remove from favorites' : 'Add to favorites';

      if (showBackground) {
        return Semantics(
          label: label,
          button: true,
          child: Tooltip(
            message: label,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.toggleFavorite(productId);
                onTapped?.call();
              },
              child: Container(
                width: size,
                height: size,
                padding: padding,
                decoration: BoxDecoration(
                  color: effectiveBgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(child: iconWidget),
              ),
            ),
          ),
        );
      }

      return Semantics(
        label: label,
        button: true,
        child: Tooltip(
          message: label,
          child: IconButton(
            iconSize: iconSize,
            padding: padding ?? EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(width: size, height: size),
            splashRadius: size / 2,
            icon: iconWidget,
            onPressed: () {
              controller.toggleFavorite(productId);
              onTapped?.call();
            },
          ),
        ),
      );
    });
  }
}
