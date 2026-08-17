import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/product_model.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'cart_controller.dart';
import 'table_session_controller.dart';

class ProductDetailsController extends GetxController {
  late Product product;

  late Rx<ProductSize> selectedSize;
  late Rx<MilkOption> selectedMilk;
  final selectedExtras = <Extra>[].obs;
  final quantity = 1.obs;

  void initProduct(Product p) {
    product = p;
    selectedSize = p.sizes.first.obs;
    selectedMilk = p.milkOptions.first.obs;
    selectedExtras.clear();
    quantity.value = 1;
  }

  void selectSize(ProductSize size) {
    selectedSize.value = size;
  }

  void selectMilk(MilkOption milk) {
    selectedMilk.value = milk;
  }

  void toggleExtra(Extra extra) {
    if (selectedExtras.contains(extra)) {
      selectedExtras.remove(extra);
    } else {
      selectedExtras.add(extra);
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  double get unitPrice {
    double base = product.basePrice * selectedSize.value.priceMultiplier;
    base += selectedMilk.value.additionalPrice;
    for (var extra in selectedExtras) {
      base += extra.price;
    }
    return base;
  }

  double get totalPrice => unitPrice * quantity.value;

  void addToCart() {
    if (Get.isRegistered<TableSessionController>()) {
      final tableCtrl = Get.find<TableSessionController>();
      if (tableCtrl.hasActiveSession) {
        tableCtrl.addItemToTableOrder(
          product: product,
          size: selectedSize.value,
          milk: selectedMilk.value,
          extras: selectedExtras.toList(),
          quantity: quantity.value,
        );
      } else {
        final cartController = Get.find<CartController>();
        cartController.addToCart(
          product: product,
          size: selectedSize.value,
          milk: selectedMilk.value,
          extras: selectedExtras.toList(),
          quantity: quantity.value,
        );
      }
    } else {
      final cartController = Get.find<CartController>();
      cartController.addToCart(
        product: product,
        size: selectedSize.value,
        milk: selectedMilk.value,
        extras: selectedExtras.toList(),
        quantity: quantity.value,
      );
    }

    Get.snackbar(
      'Added to Table Order ☕',
      '${quantity.value}x ${product.name} added to table order!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.espressoDark,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      mainButton: TextButton(
        onPressed: () => Get.toNamed(Routes.CART),
        child: const Text(
          'View Order',
          style: TextStyle(
            color: AppColors.caramel,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
