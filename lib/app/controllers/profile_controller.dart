import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/user_model.dart';

class ProfileController extends GetxController {
  static const String _keyName = 'user_name';
  static const String _keyEmail = 'user_email';
  static const String _keyPhone = 'user_phone';
  static const String _keyAvatar = 'user_avatar';

  final user = User(
    id: 'usr_1001',
    name: 'Alex Johnson',
    email: 'alex.johnson@brewora.co',
    phone: '+1 (555) 234-5678',
    profileImage: 'assets/images/avatars/avatar_1.png',
    rewardPoints: 350,
    walletBalance: 45.50,
  ).obs;

  final isSaving = false.obs;
  final isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPersistedProfile();
  }

  Future<void> _loadPersistedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_keyName);
      final email = prefs.getString(_keyEmail);
      final phone = prefs.getString(_keyPhone);
      final avatar = prefs.getString(_keyAvatar);

      if (name != null || email != null || phone != null || avatar != null) {
        user.update((u) {
          if (u != null) {
            user.value = User(
              id: u.id,
              name: name ?? u.name,
              email: email ?? u.email,
              phone: phone ?? u.phone,
              profileImage: avatar ?? u.profileImage,
              rewardPoints: u.rewardPoints,
              walletBalance: u.walletBalance,
            );
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        // debug logging only
      }
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? email,
    String? profileImage,
  }) async {
    if (isSaving.value) return false;

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return false;
    }

    final trimmedPhone = phone.trim();
    final trimmedEmail = email?.trim() ?? user.value.email;
    final finalAvatar = profileImage ?? user.value.profileImage;

    // Check if anything actually changed
    final current = user.value;
    if (current.name == trimmedName &&
        current.phone == trimmedPhone &&
        current.email == trimmedEmail &&
        current.profileImage == finalAvatar) {
      // No changes needed
      return true;
    }

    isSaving.value = true;
    try {
      // Simulated server delay / save operation
      await Future.delayed(const Duration(milliseconds: 250));

      user.value = User(
        id: current.id,
        name: trimmedName,
        email: trimmedEmail,
        phone: trimmedPhone,
        profileImage: finalAvatar,
        rewardPoints: current.rewardPoints,
        walletBalance: current.walletBalance,
      );

      // Persist to local storage
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyName, trimmedName);
        await prefs.setString(_keyPhone, trimmedPhone);
        await prefs.setString(_keyEmail, trimmedEmail);
        await prefs.setString(_keyAvatar, finalAvatar);
      } catch (_) {}

      return true;
    } catch (e) {
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void updateAvatar(String newImagePath) {
    user.value = User(
      id: user.value.id,
      name: user.value.name,
      email: user.value.email,
      phone: user.value.phone,
      profileImage: newImagePath,
      rewardPoints: user.value.rewardPoints,
      walletBalance: user.value.walletBalance,
    );

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_keyAvatar, newImagePath);
    }).catchError((_) {});
  }

  void removeAvatar() {
    updateAvatar('');
  }
}
