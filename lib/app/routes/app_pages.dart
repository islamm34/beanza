import 'package:get/get.dart';
import '../router/app_router.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/digital_menu/presentation/pages/digital_menu_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/order_tracking/presentation/pages/order_tracking_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/rewards/presentation/pages/rewards_page.dart';
import '../../features/scan_history/presentation/pages/scan_history_page.dart';
import '../../features/scanner/presentation/pages/scanner_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.INITIAL;

  static final routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const AppRouter(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.EXPLORE,
      page: () => const ExplorePage(),
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => const ProductsPage(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => const CartPage(),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => const CheckoutPage(),
    ),
    GetPage(
      name: Routes.ORDERS,
      page: () => const OrdersPage(),
    ),
    GetPage(
      name: Routes.ORDER_TRACKING,
      page: () => const OrderTrackingPage(),
    ),
    GetPage(
      name: Routes.SCANNER,
      page: () => const ScannerPage(),
    ),
    GetPage(
      name: Routes.SCAN_HISTORY,
      page: () => const ScanHistoryPage(),
    ),
    GetPage(
      name: Routes.DIGITAL_MENU,
      page: () => const DigitalMenuPage(),
    ),
    GetPage(
      name: Routes.FAVORITES,
      page: () => const FavoritesPage(),
    ),
    GetPage(
      name: Routes.REWARDS,
      page: () => const RewardsPage(),
    ),
    GetPage(
      name: Routes.WALLET,
      page: () => const WalletPage(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsPage(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsPage(),
    ),
  ];
}
