import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beanza/app/controllers/profile_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileController Comprehensive Unit Tests', () {
    late ProfileController controller;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Get.reset();
      controller = Get.put(ProfileController());
    });

    tearDown(() {
      Get.reset();
    });

    test('1. Existing profile data loads correctly', () {
      final user = controller.user.value;
      expect(user.id, equals('usr_1001'));
      expect(user.name, equals('Alex Johnson'));
      expect(user.email, equals('alex.johnson@brewora.co'));
      expect(user.phone, equals('+1 (555) 234-5678'));
      expect(user.profileImage, equals('assets/images/avatars/avatar_1.png'));
    });

    test('2. Empty name is rejected', () async {
      final success = await controller.updateProfile(
        name: '   ',
        phone: '+1 (555) 234-5678',
      );
      expect(success, isFalse);
      expect(controller.user.value.name, equals('Alex Johnson'));
    });

    test('3. Valid profile changes are saved', () async {
      final success = await controller.updateProfile(
        name: 'Jordan Smith',
        phone: '+1 (555) 987-6543',
        email: 'jordan.smith@brewora.co',
      );
      expect(success, isTrue);
      expect(controller.user.value.name, equals('Jordan Smith'));
      expect(controller.user.value.phone, equals('+1 (555) 987-6543'));
      expect(controller.user.value.email, equals('jordan.smith@brewora.co'));
    });

    test('4. Unchanged fields are preserved', () async {
      final originalEmail = controller.user.value.email;
      final originalAvatar = controller.user.value.profileImage;

      final success = await controller.updateProfile(
        name: 'Alex J.',
        phone: '+1 (555) 000-1111',
      );

      expect(success, isTrue);
      expect(controller.user.value.name, equals('Alex J.'));
      expect(controller.user.value.email, equals(originalEmail));
      expect(controller.user.value.profileImage, equals(originalAvatar));
    });

    test('5. No request is sent when nothing changed', () async {
      final success = await controller.updateProfile(
        name: controller.user.value.name,
        phone: controller.user.value.phone,
        email: controller.user.value.email,
        profileImage: controller.user.value.profileImage,
      );
      expect(success, isTrue);
      expect(controller.isSaving.value, isFalse);
    });

    test('6. Avatar update updates the avatar value immediately', () {
      const newAvatar = 'assets/images/avatars/avatar_4.png';
      controller.updateAvatar(newAvatar);
      expect(controller.user.value.profileImage, equals(newAvatar));
    });

    test('7. Removing an avatar restores fallback empty string', () {
      controller.removeAvatar();
      expect(controller.user.value.profileImage, isEmpty);
    });

    test('8. Duplicate save taps create one request and guard state', () async {
      controller.isSaving.value = true;
      final concurrentSave = await controller.updateProfile(
        name: 'Concurrent User',
        phone: '+1 234 567',
      );
      expect(concurrentSave, isFalse);
      controller.isSaving.value = false;
    });

    test('9. User changes persist in SharedPreferences', () async {
      await controller.updateProfile(
        name: 'Persistent User',
        phone: '+1 555 9999',
        profileImage: 'assets/images/avatars/avatar_3.png',
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_name'), equals('Persistent User'));
      expect(prefs.getString('user_phone'), equals('+1 555 9999'));
      expect(prefs.getString('user_avatar'),
          equals('assets/images/avatars/avatar_3.png'));
    });

    test('10. Profile state updates across application reactively', () {
      var listenerNotificationCount = 0;
      controller.user.listen((_) {
        listenerNotificationCount++;
      });

      controller.updateAvatar('assets/images/avatars/avatar_2.png');
      expect(listenerNotificationCount, equals(1));
      expect(controller.user.value.profileImage,
          equals('assets/images/avatars/avatar_2.png'));
    });
  });
}
