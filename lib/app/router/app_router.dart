import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      semanticsLabel: 'Home',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/explore.svg',
      semanticsLabel: 'Explore',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/scan.svg',
      semanticsLabel: 'Scan',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/orders.svg',
      semanticsLabel: 'Orders',
    ),
    _NavSvgItem(
      svgPath: 'assets/images/icons/profile.svg',
      semanticsLabel: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Selected Icon Color: BLUE (#2563EB) in both Light Mode & Dark Mode
    const selectedIconColor = Color(0xFF2563EB);
    final unselectedIconColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    final indicatorBgColor = const Color(0xFF2563EB)
        .withValues(alpha: isDark ? 0.22 : 0.12);

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
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardBg.withValues(alpha: 0.68)
                      : Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : AppColors.espressoDark.withValues(alpha: 0.08),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_items.length, (index) {
                    final isSelected = _currentIndex == index;
                    final item = _items[index];
                    final currentIconColor =
                        isSelected ? selectedIconColor : unselectedIconColor;

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
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.fastOutSlowIn,
                            width: 48,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? indicatorBgColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: AnimatedScale(
                                scale: isSelected ? 1.18 : 1.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.fastOutSlowIn,
                                child: SvgPicture.asset(
                                  item.svgPath,
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    currentIconColor,
                                    BlendMode.srcIn,
                                  ),
                                  semanticsLabel: item.semanticsLabel,
                                ),
                              ),
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
  final String semanticsLabel;

  const _NavSvgItem({
    required this.svgPath,
    required this.semanticsLabel,
  });
}
