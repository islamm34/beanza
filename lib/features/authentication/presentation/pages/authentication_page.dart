import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';

enum AuthViewMode { login, register, forgotPassword, otpVerification, resetPassword }

class AuthenticationPage extends StatefulWidget {
  final bool isLogin;

  const AuthenticationPage({
    Key? key,
    this.isLogin = true,
  }) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late AuthViewMode _viewMode;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _otpController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Timer? _resendTimer;
  int _resendSeconds = 30;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    _viewMode = widget.isLogin ? AuthViewMode.login : AuthViewMode.register;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendSeconds = 30;
      _canResendOtp = false;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResendOtp = true);
        timer.cancel();
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _isLoading = false);

    switch (_viewMode) {
      case AuthViewMode.login:
      case AuthViewMode.register:
        Get.snackbar(
          'Welcome to Brewora ☕',
          'Successfully authenticated! Enjoy your coffee experience.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.espressoDark,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        Get.offAllNamed(Routes.INITIAL);
        break;

      case AuthViewMode.forgotPassword:
        _startResendTimer();
        setState(() => _viewMode = AuthViewMode.otpVerification);
        Get.snackbar(
          'OTP Sent',
          'Verification code sent to ${_emailController.text.trim()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.caramel,
          colorText: AppColors.espressoDark,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        break;

      case AuthViewMode.otpVerification:
        setState(() => _viewMode = AuthViewMode.resetPassword);
        break;

      case AuthViewMode.resetPassword:
        setState(() => _viewMode = AuthViewMode.login);
        Get.snackbar(
          'Password Reset',
          'Your password has been reset successfully. Please login.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.espressoDark,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, const Color(0xFF1E1410)]
                : [AppColors.lightBg, const Color(0xFFF7F3EE)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Header Logo
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.caramel.withValues(alpha: 0.20),
                        border: Border.all(color: AppColors.caramel, width: 2),
                      ),
                      child: const Icon(
                        Icons.local_cafe_rounded,
                        size: 38,
                        color: AppColors.caramel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'BREWORA',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.5,
                            color: isDark ? Colors.white : AppColors.espressoDark,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Main Glassmorphism Auth Container
                    GlassyCard(
                      config: GlassyConfig(
                        radius: 24,
                        backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
                        backgroundOpacity: isDark ? 0.65 : 0.75,
                        borderColor: isDark ? Colors.white : AppColors.espressoDark,
                        borderOpacity: isDark ? 0.15 : 0.10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTitle(),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getSubtitle(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.getTextMutedColor(
                                      Theme.of(context).brightness,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 24),

                            // Form Fields based on ViewMode
                            if (_viewMode == AuthViewMode.register) ...[
                              TextFormField(
                                controller: _nameController,
                                validator: AppValidators.validateName,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: const Icon(Icons.person_outline_rounded),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            if (_viewMode != AuthViewMode.otpVerification &&
                                _viewMode != AuthViewMode.resetPassword) ...[
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: AppValidators.validateEmail,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            if (_viewMode == AuthViewMode.login ||
                                _viewMode == AuthViewMode.register) ...[
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator: AppValidators.validatePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            if (_viewMode == AuthViewMode.login) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => setState(
                                    () => _viewMode = AuthViewMode.forgotPassword,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.caramel,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // OTP Field
                            if (_viewMode == AuthViewMode.otpVerification) ...[
                              TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  letterSpacing: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                validator: (val) =>
                                    (val == null || val.length < 6)
                                        ? 'Enter 6-digit OTP code'
                                        : null,
                                decoration: InputDecoration(
                                  labelText: '6-Digit OTP',
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _canResendOtp
                                        ? 'Didn\'t receive code?'
                                        : 'Resend code in ${_resendSeconds}s',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  TextButton(
                                    onPressed: _canResendOtp ? _startResendTimer : null,
                                    child: const Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                        color: AppColors.caramel,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Reset Password Fields
                            if (_viewMode == AuthViewMode.resetPassword) ...[
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator: AppValidators.validatePassword,
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                validator: (val) =>
                                    AppValidators.validateConfirmPassword(
                                  val,
                                  _passwordController.text,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Confirm New Password',
                                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureConfirmPassword =
                                          !_obscureConfirmPassword,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.espressoDark,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        _getButtonText(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Switch Auth View Toggle
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _getTogglePrompt(),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  GestureDetector(
                                    onTap: _toggleAuthMode,
                                    child: Text(
                                      _getToggleAction(),
                                      style: const TextStyle(
                                        color: AppColors.caramel,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'Welcome Back';
      case AuthViewMode.register:
        return 'Create Account';
      case AuthViewMode.forgotPassword:
        return 'Forgot Password';
      case AuthViewMode.otpVerification:
        return 'Enter OTP Code';
      case AuthViewMode.resetPassword:
        return 'Reset Password';
    }
  }

  String _getSubtitle() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'Sign in to order artisan coffee and earn rewards';
      case AuthViewMode.register:
        return 'Join Brewora for exclusive coffee perks and deals';
      case AuthViewMode.forgotPassword:
        return 'Enter your email to receive a verification code';
      case AuthViewMode.otpVerification:
        return 'Verify your identity to reset your password';
      case AuthViewMode.resetPassword:
        return 'Choose a strong new password for your account';
    }
  }

  String _getButtonText() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'Sign In';
      case AuthViewMode.register:
        return 'Create Account';
      case AuthViewMode.forgotPassword:
        return 'Send Verification Code';
      case AuthViewMode.otpVerification:
        return 'Verify OTP';
      case AuthViewMode.resetPassword:
        return 'Save New Password';
    }
  }

  String _getTogglePrompt() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return "Don't have an account? ";
      case AuthViewMode.register:
      case AuthViewMode.forgotPassword:
      case AuthViewMode.otpVerification:
      case AuthViewMode.resetPassword:
        return "Remember your password? ";
    }
  }

  String _getToggleAction() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'Sign Up';
      case AuthViewMode.register:
      case AuthViewMode.forgotPassword:
      case AuthViewMode.otpVerification:
      case AuthViewMode.resetPassword:
        return 'Sign In';
    }
  }

  void _toggleAuthMode() {
    setState(() {
      if (_viewMode == AuthViewMode.login) {
        _viewMode = AuthViewMode.register;
      } else {
        _viewMode = AuthViewMode.login;
      }
    });
  }
}
