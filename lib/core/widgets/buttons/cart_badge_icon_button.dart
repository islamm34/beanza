import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/cart_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class CartBadgeIconButton extends StatelessWidget {
  final Color? iconColor;

  const CartBadgeIconButton({Key? key, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return Obx(() {
      final count = cartController.itemCount;

      return Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: iconColor ??
                  AppColors.getTextColor(Theme.of(context).brightness),
              size: 24,
            ),
            onPressed: () => Get.toNamed(Routes.CART),
            tooltip: 'Shopping Cart',
          ),
          if (count > 0)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.caramel,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: const TextStyle(
                      color: AppColors.espressoDark,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
