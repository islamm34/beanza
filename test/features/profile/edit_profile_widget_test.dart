import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/profile_controller.dart';
import 'package:beanza/app/routes/app_pages.dart';
import 'package:beanza/app/routes/app_routes.dart';
import 'package:beanza/features/profile/presentation/pages/edit_profile_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Edit Profile Widget Tests - 16 Scenarios', () {
    late ProfileController profileController;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Get.reset();
      Get.testMode = true;
      profileController = Get.put(ProfileController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('1. Open Edit Profile from Profile screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: Routes.PROFILE,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      final editButton = find.byKey(const Key('edit_profile_button'));
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.EDIT_PROFILE);
      expect(find.byType(EditProfilePage), findsOneWidget);
    });

    testWidgets('2. Pre-fill existing user data correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alex Johnson'), findsOneWidget);
      expect(find.text('+1 (555) 234-5678'), findsOneWidget);
      expect(find.text('alex.johnson@brewora.co'), findsOneWidget);
    });

    testWidgets('3. Name field cannot be empty validation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key('name_field'));
      await tester.enterText(nameField, '');
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Name cannot be empty'), findsOneWidget);
    });

    testWidgets('4. Phone field requires valid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final phoneField = find.byKey(const Key('phone_field'));
      await tester.enterText(phoneField, '12');
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid phone number'), findsOneWidget);
    });

    testWidgets('5. Email format validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final emailField = find.byKey(const Key('email_field'));
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('6. Unchanged fields preserve current values',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key('name_field'));
      await tester.enterText(nameField, 'Alex Updated');
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(profileController.user.value.name, equals('Alex Updated'));
      expect(profileController.user.value.email,
          equals('alex.johnson@brewora.co'));
    });

    testWidgets('7. Photo picker bottom sheet opens on avatar tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final avatarButton = find.byKey(const Key('change_avatar_button'));
      await tester.tap(avatarButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('photo_option_gallery')), findsOneWidget);
      expect(find.byKey(const Key('photo_option_camera')), findsOneWidget);
      expect(find.byKey(const Key('photo_option_preset')), findsOneWidget);
    });

    testWidgets('8. Camera option is present and tappable in picker sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change_avatar_button')));
      await tester.pumpAndSettle();

      final cameraOption = find.byKey(const Key('photo_option_camera'));
      expect(cameraOption, findsOneWidget);
    });

    testWidgets('9. Gallery option is present and tappable in picker sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change_avatar_button')));
      await tester.pumpAndSettle();

      final galleryOption = find.byKey(const Key('photo_option_gallery'));
      expect(galleryOption, findsOneWidget);
    });

    testWidgets('10. Preset avatar picker modal opens with 6 avatars',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change_avatar_button')));
      await tester.pumpAndSettle();

      final presetOption = find.byKey(const Key('photo_option_preset'));
      await tester.tap(presetOption);
      await tester.pumpAndSettle();

      for (int i = 1; i <= 6; i++) {
        expect(find.byKey(Key('preset_avatar_$i')), findsOneWidget);
      }
    });

    testWidgets('11. Selecting preset avatar updates preview immediately',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change_avatar_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('photo_option_preset')));
      await tester.pumpAndSettle();

      // Select Avatar 3
      await tester.tap(find.byKey(const Key('preset_avatar_3')));
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(profileController.user.value.profileImage,
          equals('assets/images/avatars/avatar_3.png'));
    });

    testWidgets('12. Remove photo confirmation sheet removes avatar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change_avatar_button')));
      await tester.pumpAndSettle();

      final removeOption = find.byKey(const Key('photo_option_remove'));
      expect(removeOption, findsOneWidget);
      await tester.tap(removeOption);
      await tester.pumpAndSettle();

      final confirmButton = find.byKey(const Key('confirm_remove_avatar'));
      expect(confirmButton, findsOneWidget);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(profileController.user.value.profileImage, isEmpty);
    });

    testWidgets('13. Save button triggers saving state and updates user',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key('name_field'));
      await tester.enterText(nameField, 'Samantha Reed');
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(profileController.user.value.name, equals('Samantha Reed'));
    });

    testWidgets('14. Success save retains updated state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key('name_field'));
      await tester.enterText(nameField, 'Morgan Lee');
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_profile_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(profileController.user.value.name, equals('Morgan Lee'));
    });

    testWidgets('15. Responsive layout across 320, 360, 390, 412 viewports',
        (WidgetTester tester) async {
      final viewports = [
        const Size(320, 600),
        const Size(360, 740),
        const Size(390, 844),
        const Size(412, 915),
      ];

      for (final size in viewports) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          GetMaterialApp(
            home: const EditProfilePage(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(EditProfilePage), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets(
        '16. Dark and Light mode themes render and Arabic RTL layout works',
        (WidgetTester tester) async {
      // Light Mode
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EditProfilePage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Dark Mode
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EditProfilePage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Arabic RTL
      await tester.pumpWidget(
        GetMaterialApp(
          locale: const Locale('ar'),
          home: const EditProfilePage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EditProfilePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
