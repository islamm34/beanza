import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _navigationTriggered = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
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
      FlutterNativeSplash.remove();
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

    return Scaffold(
      backgroundColor: AppColors.espressoDark,
      body: Center(
        child: isReducedMotion
            ? Image.asset(
                'assets/logos/brewora_splash_logo.png',
                width: 220,
                fit: BoxFit.contain,
              )
            : FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logos/brewora_splash_logo.png',
                        width: 220,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
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
              ),
      ),
    );
  }
}
