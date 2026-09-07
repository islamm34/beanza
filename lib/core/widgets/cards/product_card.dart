import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../buttons/favorite_button.dart';

class ProductCard extends StatelessWidget {
  final String? productId;
  final String imageUrl;
  final String name;
  final String category;
  final double price;
  final double? rating;
  final int? reviewCount;
  final VoidCallback onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;
  final bool showSubtleShadow;

  const ProductCard({
    Key? key,
    this.productId,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.price,
    this.rating,
    this.reviewCount,
    required this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
    this.showSubtleShadow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final glassyBgColor = isDark ? AppColors.darkCardBg : Colors.white;

    final glassyBorderColor = isDark ? Colors.white : AppColors.espressoDark;

    final cardContent = GlassyCard(
      config: GlassyConfig(
        radius: AppRadius.card,
        backgroundColor: glassyBgColor,
        backgroundOpacity: isDark ? 0.60 : 0.65,
        borderColor: glassyBorderColor,
        borderOpacity: isDark ? 0.18 : 0.10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Image Section - Occupies ~55% of Card Height & Full Width
          Expanded(
            flex: 55,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.card),
                      topRight: Radius.circular(AppRadius.card),
                    ),
                    child: imageUrl.startsWith('assets/')
                        ? Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (_, __, ___) =>
                                _buildImageFallback(isDark),
                          )
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (_, __, ___) =>
                                _buildImageFallback(isDark),
                          ),
                  ),
                ),
                if (productId != null)
                  Positioned(
                    top: AppSpacing.xs + 4,
                    right: AppSpacing.xs + 4,
                    child: FavoriteButton(
                      productId: productId!,
                      size: 30,
                      iconSize: 16,
                      onTapped: onFavoritePressed,
                    ),
                  )
                else if (onFavoritePressed != null)
                  Positioned(
                    top: AppSpacing.xs + 4,
                    right: AppSpacing.xs + 4,
                    child: GestureDetector(
                      onTap: onFavoritePressed,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.90),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? AppColors.error
                              : AppColors.textMuted,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Product Info Section - Occupies ~45% of Card Height
          Expanded(
            flex: 45,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm + 2,
                AppSpacing.xs + 4,
                AppSpacing.sm + 2,
                AppSpacing.xs + 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.getTextMutedColor(
                                Theme.of(context).brightness,
                              ),
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${price.toStringAsFixed(2)} ${'egp'.tr}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.goldBright
                              : AppColors.goldLight,
                          fontSize: 14,
                        ),
                      ),
                      if (rating != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 15,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$rating',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (showSubtleShadow) {
      final shadowColor = isDark
          ? Colors.black.withValues(alpha: 0.35)
          : const Color(0xFF2C1B10).withValues(alpha: 0.15);

      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: glassyBgColor,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: isDark ? 18 : 16,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: cardContent,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: cardContent,
    );
  }

  Widget _buildImageFallback(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkCardBg : AppColors.softSand,
      child: const Center(
        child: Icon(
          Icons.coffee_rounded,
          color: AppColors.caramel,
          size: 36,
        ),
      ),
    );
  }
}
