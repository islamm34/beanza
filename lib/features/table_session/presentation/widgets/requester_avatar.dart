import 'package:flutter/material.dart';

class RequesterAvatar extends StatelessWidget {
  final String name;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final IconData? badgeIcon;
  final Color? badgeColor;

  const RequesterAvatar({
    Key? key,
    required this.name,
    this.size = 72,
    this.showBorder = true,
    this.borderColor,
    this.badgeIcon,
    this.badgeColor,
  }) : super(key: key);

  String _getInitials(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length > 1 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor =
        isDark ? const Color(0xFFD0932F) : const Color(0xFFB6781E);
    final goldBright =
        isDark ? const Color(0xFFF1B447) : const Color(0xFFB6781E);
    final activeBorderColor = borderColor ?? goldColor;
    final initials = _getInitials(name);

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: goldColor.withValues(alpha: isDark ? 0.22 : 0.15),
        border: showBorder
            ? Border.all(
                color: activeBorderColor,
                width: size > 60 ? 2.5 : 1.8,
              )
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: (isDark ? const Color(0xFFD0932F) : Colors.black)
                      .withValues(alpha: isDark ? 0.25 : 0.10),
                  blurRadius: size > 60 ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: goldBright,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.38,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );

    if (badgeIcon != null) {
      final effectiveBadgeColor = badgeColor ?? goldColor;
      final badgeSize = size * 0.34;

      return Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: effectiveBadgeColor,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF080B09)
                      : const Color(0xFFF6F1E7),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  badgeIcon,
                  size: badgeSize * 0.60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return avatar;
  }
}
