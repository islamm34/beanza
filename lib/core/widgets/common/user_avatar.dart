import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String? customImagePath;
  final String? userName;
  final bool showBorder;
  final Color? borderColor;
  final VoidCallback? onTap;

  const UserAvatar({
    Key? key,
    this.size = 56,
    this.customImagePath,
    this.userName,
    this.showBorder = true,
    this.borderColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final activeBorderColor = borderColor ?? goldColor;

    Widget avatarContent;
    if (customImagePath != null) {
      avatarContent = _buildImageOrFallback(
        context,
        customImagePath!,
        userName ?? '',
        isDark,
        goldColor,
      );
    } else if (Get.isRegistered<ProfileController>()) {
      avatarContent = Obx(() {
        final profileController = Get.find<ProfileController>();
        final imagePath = profileController.user.value.profileImage;
        final name = (userName != null && userName!.isNotEmpty)
            ? userName!
            : profileController.user.value.name;
        return _buildImageOrFallback(
          context,
          imagePath,
          name,
          isDark,
          goldColor,
        );
      });
    } else {
      avatarContent = _buildImageOrFallback(
        context,
        '',
        userName ?? '',
        isDark,
        goldColor,
      );
    }

    final container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: activeBorderColor,
                width: size > 70 ? 2.5 : 1.8,
              )
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: (isDark ? AppColors.gold : AppColors.espressoDark)
                      .withValues(alpha: isDark ? 0.20 : 0.12),
                  blurRadius: size > 70 ? 16 : 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ClipOval(child: avatarContent),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    return container;
  }

  Widget _buildImageOrFallback(
    BuildContext context,
    String path,
    String name,
    bool isDark,
    Color goldColor,
  ) {
    if (path.isEmpty) {
      return _buildInitialsOrIconFallback(name, isDark, goldColor);
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitialsOrIconFallback(name, isDark, goldColor),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
            child: Center(
              child: SizedBox(
                width: size * 0.4,
                height: size * 0.4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: goldColor,
                ),
              ),
            ),
          );
        },
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitialsOrIconFallback(name, isDark, goldColor),
      );
    }

    // Local file path from camera/gallery
    try {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildInitialsOrIconFallback(name, isDark, goldColor),
        );
      }
    } catch (_) {
      // Fallback on any file read error
    }

    return _buildInitialsOrIconFallback(name, isDark, goldColor);
  }

  Widget _buildInitialsOrIconFallback(
    String name,
    bool isDark,
    Color goldColor,
  ) {
    final initials = _getInitials(name);

    return Container(
      width: size,
      height: size,
      color: goldColor.withValues(alpha: isDark ? 0.22 : 0.15),
      child: Center(
        child: initials.isNotEmpty
            ? Text(
                initials,
                style: TextStyle(
                  color: isDark ? AppColors.goldBright : goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.38,
                  letterSpacing: 0.5,
                ),
              )
            : Icon(
                Icons.person_rounded,
                size: size * 0.55,
                color: goldColor,
              ),
      ),
    );
  }

  String _getInitials(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length > 1 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }
}
