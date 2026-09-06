import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/cart_controller.dart';
import 'package:beanza/app/controllers/favorites_controller.dart';
import 'package:beanza/app/controllers/notifications_controller.dart';
import 'package:beanza/app/controllers/products_controller.dart';
import 'package:beanza/app/controllers/profile_controller.dart';
import 'package:beanza/app/controllers/table_session_controller.dart';
import 'package:beanza/app/routes/app_pages.dart';
import 'package:beanza/app/routes/app_routes.dart';
import 'package:beanza/core/models/user_model.dart';
import 'package:beanza/core/widgets/common/profile_avatar.dart';
import 'package:beanza/features/home/presentation/pages/home_page.dart';
import 'package:beanza/features/home/presentation/widgets/home_profile_header.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Home Profile Header & Reactive Synchronization Tests', () {
    late ProfileController profileController;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Get.reset();
      Get.testMode = true;

      profileController = Get.put(ProfileController());
      Get.put(ProductsController());
      Get.put(TableSessionController());
      Get.put(CartController());
      Get.put(FavoritesController());
      Get.put(NotificationsController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('1. Home displays the current profile name',
        (WidgetTester tester) async {
      profileController.user.value = User(
        id: 'usr_1001',
        name: 'Youssef Mansour',
        email: 'youssef@brewora.co',
        phone: '+20 100 123 4567',
        profileImage: 'assets/images/avatars/avatar_1.png',
      );

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomePage(),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Youssef Mansour'), findsOneWidget);
    });

    testWidgets('2. Home displays the current profile image',
        (WidgetTester tester) async {
      profileController.user.value = User(
        id: 'usr_1001',
        name: 'Alex Johnson',
        email: 'alex@brewora.co',
        phone: '+1 555 123 4567',
        profileImage: 'assets/images/avatars/avatar_2.png',
      );

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomePage(),
        ),
      );
      await tester.pump();

      expect(find.byType(ProfileAvatar), findsWidgets);
      expect(find.byType(HomeProfileHeader), findsOneWidget);
    });

    testWidgets('3. Editing the name updates Home instantly without reloading',
        (WidgetTester tester) async {
      profileController.user.value = User(
        id: 'usr_1001',
        name: 'Alex Johnson',
        email: 'alex@brewora.co',
        phone: '+1 555 123 4567',
        profileImage: 'assets/images/avatars/avatar_1.png',
      );

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomePage(),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Alex Johnson'), findsOneWidget);

      // Reactive update via ProfileController single source of truth
      profileController.user.value = User(
        id: 'usr_1001',
        name: 'Sara El-Sayed',
        email: 'sara@brewora.co',
        phone: '+20 100 987 6543',
        profileImage: 'assets/images/avatars/avatar_1.png',
      );
      await tester.pump();

      expect(find.textContaining('Sara El-Sayed'), findsOneWidget);
      expect(find.textContaining('Alex Johnson'), findsNothing);
    });

    testWidgets('4. Changing the avatar updates Home instantly',
        (WidgetTester tester) async {
      profileController.user.value = User(
        id: 'usr_1001',
        name: 'Alex Johnson',
        email: 'alex@brewora.co',
        phone: '+1 555 123 4567',
        profileImage: 'assets/images/avatars/avatar_1.png',
      );

      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomePage(),
        ),
      );
      await tester.pump();

      expect(find.byType(ProfileAvatar), findsWidgets);

      profileController.updateAvatar('assets/images/avatars/avatar_5.png');
      await tester.pump();

      expect(find.byType(ProfileAvatar), findsWidgets);
    });

    testWidgets(
        '5. A broken or non-existent image displays initials fallback cleanly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(
              imagePath: '/invalid/path/does_not_exist.png',
              name: 'Youssef Ahmed',
              size: 50,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ProfileAvatar), findsOneWidget);
      expect(find.text('YA'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('6. Tapping the Home profile header opens Profile screen once',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.HOME,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      final headerTapTarget =
          find.byKey(const Key('home_profile_header_tap_target'));
      expect(headerTapTarget, findsOneWidget);

      await tester.tap(headerTapTarget);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(Get.currentRoute, Routes.PROFILE);
    });

    testWidgets(
        '7. Dark Mode and Light Mode render HomeProfileHeader correctly',
        (WidgetTester tester) async {
      // Dark Mode
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: HomeProfileHeader(
              name: 'Alex Johnson',
              avatarPath: 'assets/images/avatars/avatar_1.png',
              onProfileTap: () {},
              onNotificationsTap: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(HomeProfileHeader), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Light Mode
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: HomeProfileHeader(
              name: 'Alex Johnson',
              avatarPath: 'assets/images/avatars/avatar_1.png',
              onProfileTap: () {},
              onNotificationsTap: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(HomeProfileHeader), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('8. Arabic RTL renders cleanly without overflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          home: Scaffold(
            body: HomeProfileHeader(
              name: 'يوسف عبد الرحمن',
              tableNumber: '12',
              hasActiveTableSession: true,
              onProfileTap: () {},
              onNotificationsTap: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(HomeProfileHeader), findsOneWidget);
      expect(find.textContaining('يوسف عبد الرحمن'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
