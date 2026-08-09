import 'package:get/get.dart';
import '../../core/services/notification_service.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/orders_controller.dart';
import '../controllers/product_details_controller.dart';
import '../controllers/products_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/rewards_controller.dart';
import '../controllers/scan_history_controller.dart';
import '../controllers/wallet_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<NotificationService>(() => NotificationService().init(),
        permanent: true);

    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<FavoritesController>(() => FavoritesController(), fenix: true);
    Get.lazyPut<ProductsController>(() => ProductsController(), fenix: true);
    Get.lazyPut<ProductDetailsController>(
      () => ProductDetailsController(),
      fenix: true,
    );
    Get.lazyPut<OrdersController>(() => OrdersController(), fenix: true);
    Get.lazyPut<ScanHistoryController>(
      () => ScanHistoryController(),
      fenix: true,
    );
    Get.lazyPut<WalletController>(() => WalletController(), fenix: true);
    Get.lazyPut<RewardsController>(() => RewardsController(), fenix: true);
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
