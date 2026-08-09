import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String category;
  final double price;
  final double? rating;
  final int? reviewCount;
  final VoidCallback onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.price,
    this.rating,
    this.reviewCount,
    required this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCardBg : AppColors.lightCardBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.card),
                    topRight: Radius.circular(AppRadius.card),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      color: AppColors.softSand,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: GestureDetector(
                    onTap: onFavoritePressed,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? AppColors.error
                            : AppColors.textMuted,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.getTextMutedColor(
                        Theme.of(context).brightness,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.coffeeBrown,
                        ),
                      ),
                      if (rating != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$rating',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (reviewCount != null)
                              Text(
                                ' ($reviewCount)',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.getTextMutedColor(
                                        Theme.of(context).brightness,
                                      ),
                                    ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
