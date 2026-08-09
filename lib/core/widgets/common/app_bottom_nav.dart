import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class AppBottomNav extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final List<AppBottomNavItem> items;

  const AppBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCardBg : AppColors.lightCardBg;

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: widget.items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
              backgroundColor: bgColor,
            ),
          )
          .toList(),
      backgroundColor: bgColor,
      selectedItemColor: AppColors.coffeeBrown,
      unselectedItemColor: AppColors.textMuted,
      elevation: 10,
    );
  }
}

class AppBottomNavItem {
  final IconData icon;
  final String label;

  AppBottomNavItem({required this.icon, required this.label});
}
