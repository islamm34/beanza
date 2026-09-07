import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/widgets/buttons/favorite_button.dart';

class HomeProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavoritePressed;
  final bool? isFavorite;
  final bool showSubtleShadow;

  const HomeProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    this.onFavoritePressed,
    this.isFavorite,
    this.showSubtleShadow = true,
  }) : super(key: key);

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard>
  with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCardBg : AppColors.lightCardBg;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    final cardContent = Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cardBorder,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Image Section (flex: 54)
          Expanded(
            flex: 54,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(17)),
                    child: widget.product.image.startsWith('assets/')
                        ? Image.asset(
                            widget.product.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (_, __, ___) =>
                                _buildImageFallback(isDark),
                          )
                        : Image.network(
                            widget.product.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (_, __, ___) =>
                                _buildImageFallback(isDark),
                          ),
                  ),
                ),
                // Gradient overlay at bottom of image
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.25),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // New/Popular Badges (Top Left)
                if (widget.product.isNew || widget.product.isPopular)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: widget.product.isNew
                            ? AppColors.primaryGreen
                            : goldColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.product.isNew
                            ? 'badge_new'.tr
                            : 'badge_popular'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    productId: widget.product.id,
                    size: 28,
                    iconSize: 15,
                    onTapped: widget.onFavoritePressed,
                  ),
                ),
              ],
            ),
          ),

          // 2. Bottom Info Section (flex: 46)
          Expanded(
            flex: 46,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Localized Product Name
                      Text(
                        widget.product.localizedName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 1.5),
                      // Localized Product Category / Description
                      Text(
                        widget.product.localizedCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Row: Gold Price & Green Circular Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Gold Price
                      Text(
                        '${widget.product.basePrice.toStringAsFixed(2)} ${'egp'.tr}',
                        style: TextStyle(
                          color: isDark ? AppColors.goldBright : goldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      // Green Circular Add Button
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: greenColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: greenColor.withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
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

    Widget animatedCard = ScaleTransition(
      scale: _scaleAnimation,
      child: cardContent,
    );

    if (widget.showSubtleShadow) {
      final shadowColor = isDark
          ? Colors.black.withValues(alpha: 0.30)
          : const Color(0xFF2C1B10).withValues(alpha: 0.06);

      animatedCard = Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: isDark ? 14 : 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: animatedCard,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: animatedCard,
    );
  }

  Widget _buildImageFallback(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkCardElevated : AppColors.lightSecondaryBg,
      child: Center(
        child: Icon(
          Icons.coffee_rounded,
          color: isDark ? AppColors.gold : AppColors.goldLight,
          size: 32,
        ),
      ),
    );
  }
}
