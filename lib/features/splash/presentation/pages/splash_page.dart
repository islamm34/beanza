import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

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
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
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
    await Future.delayed(const Duration(milliseconds: 1000));

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
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Responsive logo width: 45% of screen width, clamped between 160.0 and 260.0
    final logoWidth = (screenWidth * 0.45).clamp(160.0, 260.0);

    final logoWidget = SvgPicture.asset(
      'assets/branding/brewora_splash_logo.svg',
      width: logoWidth,
      fit: BoxFit.contain,
      semanticsLabel: 'Brewora logo',
    );

    final contentWidget = Stack(
      children: [
        // Centered logo matching native splash alignment exactly
        Align(
          alignment: Alignment.center,
          child: isReducedMotion
              ? logoWidget
              : ScaleTransition(
                  scale: _scaleAnimation,
                  child: logoWidget,
                ),
        ),
        // Branding text and progress indicator positioned below the logo
        Positioned(
          left: 0,
          right: 0,
          bottom: screenHeight * 0.15,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'BREWORA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Artisan Coffee, Delivered Fresh',
                style: TextStyle(
                  color: AppColors.caramel.withValues(alpha: 0.90),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 36),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.caramel,
                  strokeWidth: 2.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.espressoDark,
      body: isReducedMotion
          ? contentWidget
          : FadeTransition(
              opacity: _fadeAnimation,
              child: contentWidget,
            ),
    );
  }
}
