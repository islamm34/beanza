import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/favorites_controller.dart';
import '../../../../app/controllers/product_details_controller.dart';
import '../../../../core/widgets/cards/product_card.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../products/presentation/pages/products_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Favorites',
      ),
      body: Obx(() {
        final products = favoritesController.favoriteProducts;

        if (products.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border_rounded,
            title: 'No Favorites Saved',
            message: 'Tap the heart icon on any coffee item to save it here!',
            actionLabel: 'Explore Coffee Menu',
            onAction: () => Get.toNamed('/home'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              productId: product.id,
              imageUrl: product.image,
              name: product.name,
              category: product.category,
              price: product.basePrice,
              rating: product.rating,
              reviewCount: product.reviewsCount,
              onTap: () {
                Get.find<ProductDetailsController>().initProduct(product);
                Get.to(
                  () => ProductsPage(productId: product.id),
                );
              },
            );
          },
        );
      }),
    );
  }
}
