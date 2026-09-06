import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _navigationTriggered = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Remove native splash on first frame & start brand animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        FlutterNativeSplash.remove();
      } catch (e) {
        // Safe fallback if native splash is already removed or not active
      }
      if (mounted) {
        _animController.forward();
        _initializeAppAndNavigate();
      }
    });
  }

  Future<void> _initializeAppAndNavigate() async {
    // Perform essential initialization / minimum brand duration
    await Future.delayed(const Duration(milliseconds: 3500));

    if (mounted && !_navigationTriggered) {
      _navigationTriggered = true;
      if (Get.isRegistered<TableSessionController>() &&
          Get.find<TableSessionController>().hasActiveSession) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.SCANNER);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isReducedMotion = mediaQuery.disableAnimations;
    final shortestSide =
        math.min(mediaQuery.size.width, mediaQuery.size.height);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF080B09) : const Color(0xFFF6F1E7);

    // Responsive width: approximately 34%–42% of shortest screen side
    final logoSize = (shortestSide * 0.38).clamp(130.0, 240.0);

    final logoWidget = Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? const Color(0xFFD39A35).withValues(alpha: 0.22)
                : const Color(0xFF5A2D18).withValues(alpha: 0.16),
            blurRadius: isDarkMode ? 28 : 20,
            spreadRadius: isDarkMode ? 2 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SvgPicture.asset(
        'assets/premium_cafe_3d_logo.svg',
        fit: BoxFit.contain,
        semanticsLabel: 'Cafe logo',
      ),
    );

    final animatedLogo = isReducedMotion
        ? logoWidget
        : ScaleTransition(
            scale: _scaleAnimation,
            child: logoWidget,
          );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: isReducedMotion
            ? animatedLogo
            : FadeTransition(
                opacity: _fadeAnimation,
                child: animatedLogo,
              ),
      ),
    );
  }
}
