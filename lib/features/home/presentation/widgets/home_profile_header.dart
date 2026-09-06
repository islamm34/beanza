import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/cart_badge_icon_button.dart';
import '../../../../core/widgets/common/profile_avatar.dart';

class HomeProfileHeader extends StatelessWidget {
  final String name;
  final String? avatarPath;
  final String? tableNumber;
  final bool hasActiveTableSession;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationsTap;

  const HomeProfileHeader({
    Key? key,
    required this.name,
    this.avatarPath,
    this.tableNumber,
    this.hasActiveTableSession = false,
    required this.onProfileTap,
    required this.onNotificationsTap,
  }) : super(key: key);

  String get _timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  String get _timeBasedGreetingAr {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير،';
    } else {
      return 'مساء الخير،';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Profile Avatar + Greeting + Name + Table/Branch subtitle
          Expanded(
            child: GestureDetector(
              key: const Key('home_profile_header_tap_target'),
              behavior: HitTestBehavior.opaque,
              onTap: onProfileTap,
              child: Row(
                children: [
                  ProfileAvatar(
                    imagePath: avatarPath,
                    name: name,
                    size: 44,
                    showBorder: true,
                    borderColor: hasActiveTableSession ? greenColor : goldColor,
                    onTap: onProfileTap,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '$_timeBasedGreeting $name',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (hasActiveTableSession && tableNumber != null)
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: greenColor,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  'Table $tableNumber • طاولة $tableNumber',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: greenColor,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 13,
                                color: goldColor,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Brewora Artisan Café • Branch 1',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Right Side: Cart Badge & Notifications Action
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightSecondaryBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: const CartBadgeIconButton(),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightSecondaryBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: IconButton(
                  key: const Key('home_notifications_button'),
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                  ),
                  color: primaryText,
                  onPressed: onNotificationsTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
