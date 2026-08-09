import 'package:get/get.dart';
import '../../core/data/local_product_catalog.dart';
import '../../core/models/product_model.dart';

class FavoritesController extends GetxController {
  final favoriteProductIds = <String>{'prod_1', 'prod_4', 'prod_15'}.obs;

  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (favoriteProductIds.contains(productId)) {
      favoriteProductIds.remove(productId);
    } else {
      favoriteProductIds.add(productId);
    }
  }

  List<Product> get favoriteProducts {
    return LocalProductCatalog.products
        .where((p) => favoriteProductIds.contains(p.id))
        .toList();
  }
}
