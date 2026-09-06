import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/user_avatar.dart';

class EditProfilePage extends StatefulWidget {
  final ImagePicker? imagePicker;

  const EditProfilePage({
    Key? key,
    this.imagePicker,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileController _profileController;
  late final ImagePicker _picker;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String? _selectedAvatarPath;
  bool _isPhotoRemoved = false;

  static const List<String> presetAvatars = [
    'assets/images/avatars/avatar_1.png',
    'assets/images/avatars/avatar_2.png',
    'assets/images/avatars/avatar_3.png',
    'assets/images/avatars/avatar_4.png',
    'assets/images/avatars/avatar_5.png',
    'assets/images/avatars/avatar_6.png',
  ];

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _picker = widget.imagePicker ?? ImagePicker();

    final currentUser = _profileController.user.value;
    _nameController = TextEditingController(text: currentUser.name);
    _phoneController = TextEditingController(text: currentUser.phone);
    _emailController = TextEditingController(text: currentUser.email);
    _selectedAvatarPath = currentUser.profileImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String get _currentDisplayImagePath {
    if (_isPhotoRemoved) return '';
    return _selectedAvatarPath ?? _profileController.user.value.profileImage;
  }

  void _showPhotoOptionsSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final hasPhoto = _currentDisplayImagePath.isNotEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Change Profile Photo / تغيير الصورة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  key: const Key('photo_option_gallery'),
                  leading: CircleAvatar(
                    backgroundColor: goldColor.withValues(alpha: 0.15),
                    child: Icon(Icons.photo_library_rounded, color: goldColor),
                  ),
                  title: Text(
                    'Choose From Gallery / اختيار من المعرض',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  key: const Key('photo_option_camera'),
                  leading: CircleAvatar(
                    backgroundColor: goldColor.withValues(alpha: 0.15),
                    child: Icon(Icons.camera_alt_rounded, color: goldColor),
                  ),
                  title: Text(
                    'Take a Photo / التقاط صورة',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  key: const Key('photo_option_preset'),
                  leading: CircleAvatar(
                    backgroundColor: goldColor.withValues(alpha: 0.15),
                    child: Icon(Icons.face_rounded, color: goldColor),
                  ),
                  title: Text(
                    'Choose Preset Avatar / اختيار شخصية قهوة',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showPresetAvatarsDialog();
                  },
                ),
                if (hasPhoto)
                  ListTile(
                    key: const Key('photo_option_remove'),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.error.withValues(alpha: 0.15),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: AppColors.error),
                    ),
                    title: const Text(
                      'Remove Current Photo / حذف الصورة',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _confirmRemovePhoto();
                    },
                  ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel / إلغاء',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 88,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final sizeInBytes = await file.length();
        if (sizeInBytes > 5 * 1024 * 1024) {
          Get.snackbar(
            'Image Too Large',
            'Please select an image smaller than 5 MB.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
          return;
        }

        setState(() {
          _selectedAvatarPath = pickedFile.path;
          _isPhotoRemoved = false;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Could not load image',
        'Please check device permissions and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  void _showPresetAvatarsDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select a Café Avatar / اختر شخصيتك',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: presetAvatars.length,
                  itemBuilder: (context, index) {
                    final avatarPath = presetAvatars[index];
                    final isSelected =
                        _selectedAvatarPath == avatarPath && !_isPhotoRemoved;

                    return GestureDetector(
                      key: Key('preset_avatar_${index + 1}'),
                      onTap: () {
                        setState(() {
                          _selectedAvatarPath = avatarPath;
                          _isPhotoRemoved = false;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? goldColor
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                            width: isSelected ? 3.0 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: goldColor.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            avatarPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel / إلغاء',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmRemovePhoto() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Remove Profile Photo?',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove your profile photo and use the default avatar?',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              key: const Key('confirm_remove_avatar'),
              onPressed: () {
                setState(() {
                  _selectedAvatarPath = '';
                  _isPhotoRemoved = true;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_profileController.isSaving.value) return;

    final success = await _profileController.updateProfile(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      profileImage: _isPhotoRemoved ? '' : _selectedAvatarPath,
    );

    if (success) {
      Get.snackbar(
        'Profile Updated',
        'Your profile changes have been saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      Get.back();
    } else {
      Get.snackbar(
        'Could Not Save Profile',
        'Please check your network and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: const AppAppBar(
        title: 'Edit Profile / تعديل الحساب',
        showCartAction: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Profile Avatar with Edit Camera Overlay
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      UserAvatar(
                        key: const Key('change_avatar_button'),
                        size: 110,
                        customImagePath: _currentDisplayImagePath,
                        userName: _nameController.text.isNotEmpty
                            ? _nameController.text
                            : _profileController.user.value.name,
                        onTap: _showPhotoOptionsSheet,
                      ),
                      GestureDetector(
                        onTap: _showPhotoOptionsSheet,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: goldColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isDark ? AppColors.darkBg : AppColors.lightBg,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                            color: AppColors.espressoDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _showPhotoOptionsSheet,
                  icon: Icon(Icons.edit_rounded, size: 16, color: goldColor),
                  label: Text(
                    'Change Photo / تغيير الصورة',
                    style: TextStyle(
                      color: goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Full Name Input
                _buildInputField(
                  fieldKey: const Key('name_field'),
                  controller: _nameController,
                  label: 'Full Name / الاسم الكامل',
                  hint: 'e.g. Alex Johnson',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name cannot be empty';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  isDark: isDark,
                  goldColor: goldColor,
                ),
                const SizedBox(height: 18),

                // 3. Phone Number Input
                _buildInputField(
                  fieldKey: const Key('phone_field'),
                  controller: _phoneController,
                  label: 'Phone Number / رقم الهاتف',
                  hint: 'e.g. +1 (555) 234-5678',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number cannot be empty';
                    }
                    return AppValidators.validatePhone(value);
                  },
                  isDark: isDark,
                  goldColor: goldColor,
                ),
                const SizedBox(height: 18),

                // 4. Email Address Input
                _buildInputField(
                  fieldKey: const Key('email_field'),
                  controller: _emailController,
                  label: 'Email Address / البريد الإلكتروني',
                  hint: 'e.g. alex@brewora.co',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                  isDark: isDark,
                  goldColor: goldColor,
                ),
                const SizedBox(height: 36),

                // 5. Save Changes Button
                Obx(() {
                  final isSaving = _profileController.isSaving.value;

                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      key: const Key('save_profile_button'),
                      onPressed: isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline_rounded,
                                      size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Save Changes / حفظ التغييرات',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    Key? fieldKey,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color goldColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 14.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                  : AppColors.lightTextSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: goldColor, size: 20),
            filled: true,
            fillColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: goldColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
