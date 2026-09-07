import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/scanner/presentation/pages/scanner_page.dart';
import '../theme/app_colors.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _currentIndex = 0;

  final List<_NavSvgItem> _items = const [
    _NavSvgItem(
      svgPath: 'assets/images/icons/home.svg',
      labelKey: 'nav_home',
      semanticsKey: 'nav_home',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/explore.svg',
      labelKey: 'nav_explore',
      semanticsKey: 'nav_explore',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/scan.svg',
      labelKey: 'nav_scan',
      semanticsKey: 'nav_scan',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/orders.svg',
      labelKey: 'nav_orders',
      semanticsKey: 'nav_orders',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/profile.svg',
      labelKey: 'nav_profile',
      semanticsKey: 'nav_profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeGreen =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;
    final inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: _buildPage(_currentIndex),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: 68,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardBg.withValues(alpha: 0.92)
                      : AppColors.lightCardBg.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_items.length, (index) {
                    final isSelected = _currentIndex == index;
                    final item = _items[index];

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_currentIndex != index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.fastOutSlowIn,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? activeGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  item.svgPath,
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    isSelected ? Colors.white : inactiveColor,
                                    BlendMode.srcIn,
                                  ),
                                  semanticsLabel: item.semanticsKey.tr,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.labelKey.tr,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : inactiveColor,
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const ExplorePage();
      case 2:
        return const ScannerPage();
      case 3:
        return const OrdersPage();
      case 4:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }
}

class _NavSvgItem {
  final String svgPath;
  final String labelKey;
  final String semanticsKey;

  const _NavSvgItem({
    required this.svgPath,
    required this.labelKey,
    required this.semanticsKey,
  });
}
