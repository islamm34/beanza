import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final String? name;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final VoidCallback? onTap;

  const ProfileAvatar({
    Key? key,
    this.imagePath,
    this.name,
    this.size = 44,
    this.showBorder = true,
    this.borderColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final activeBorderColor = borderColor ?? goldColor;

    final avatarContent = _buildImageWithFallback(
      context: context,
      path: imagePath?.trim() ?? '',
      userName: name?.trim() ?? '',
      isDark: isDark,
      goldColor: goldColor,
    );

    final container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: activeBorderColor,
                width: size > 60 ? 2.0 : 1.4,
              )
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: (isDark ? AppColors.gold : AppColors.espressoDark)
                      .withValues(alpha: isDark ? 0.20 : 0.10),
                  blurRadius: size > 60 ? 12 : 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipOval(child: avatarContent),
    );

    if (onTap != null) {
      return GestureDetector(
        key: const Key('profile_avatar_tap_target'),
        onTap: onTap,
        child: container,
      );
    }
    return container;
  }

  Widget _buildImageWithFallback({
    required BuildContext context,
    required String path,
    required String userName,
    required bool isDark,
    required Color goldColor,
  }) {
    if (path.isEmpty) {
      return _buildInitialsOrIconFallback(userName, isDark, goldColor);
    }

    // 1. Local file path from camera / gallery
    if (!path.startsWith('http') && !path.startsWith('assets/')) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildInitialsOrIconFallback(userName, isDark, goldColor),
          );
        }
      } catch (_) {
        // Fallback safely
      }
    }

    // 2. Saved network photo
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitialsOrIconFallback(userName, isDark, goldColor),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: isDark
                ? AppColors.darkCardElevated
                : AppColors.lightSecondaryBg,
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

    // 3. Selected preset avatar asset
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitialsOrIconFallback(userName, isDark, goldColor),
      );
    }

    // 4 & 5. Initials or Default profile icon
    return _buildInitialsOrIconFallback(userName, isDark, goldColor);
  }

  Widget _buildInitialsOrIconFallback(
    String userName,
    bool isDark,
    Color goldColor,
  ) {
    final initials = _getInitials(userName);

    return Container(
      width: size,
      height: size,
      color: goldColor.withValues(alpha: isDark ? 0.22 : 0.14),
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
