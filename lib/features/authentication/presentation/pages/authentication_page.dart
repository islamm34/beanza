import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/common/adaptive_cafe_logo.dart';

enum AuthViewMode {
  login,
  register,
  forgotPassword,
  otpVerification,
  resetPassword
}

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
          'auth_welcome_snackbar_title'.tr,
          'auth_welcome_snackbar_msg'.tr,
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
          'auth_otp_sent_title'.tr,
          'auth_otp_sent_msg'.trParams({'email': _emailController.text.trim()}),
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
          'auth_password_reset_title'.tr,
          'auth_password_reset_msg'.tr,
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
                    AdaptiveCafeLogo(
                      size: 88,
                      semanticsLabel: 'brewora_logo_label'.tr,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'auth_welcome_title'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.5,
                            color:
                                isDark ? Colors.white : AppColors.espressoDark,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Main Glassmorphism Auth Container
                    GlassyCard(
                      config: GlassyConfig(
                        radius: 24,
                        backgroundColor:
                            isDark ? AppColors.darkCardBg : Colors.white,
                        backgroundOpacity: isDark ? 0.65 : 0.75,
                        borderColor:
                            isDark ? Colors.white : AppColors.espressoDark,
                        borderOpacity: isDark ? 0.15 : 0.10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTitle(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getSubtitle(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
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
                                  labelText: 'auth_full_name_label'.tr,
                                  prefixIcon:
                                      const Icon(Icons.person_outline_rounded),
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
                                  labelText: 'auth_email_label'.tr,
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
                                  labelText: 'auth_password_label'.tr,
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
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
                                    () =>
                                        _viewMode = AuthViewMode.forgotPassword,
                                  ),
                                  child: Text(
                                    'auth_forgot_password_btn'.tr,
                                    style: const TextStyle(
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
                                        ? 'auth_otp_validation_error'.tr
                                        : null,
                                decoration: InputDecoration(
                                  labelText: 'auth_otp_label'.tr,
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _canResendOtp
                                        ? 'auth_didnt_receive_code'.tr
                                        : 'auth_resend_in_seconds'.trParams({'seconds': '$_resendSeconds'}),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  TextButton(
                                    onPressed: _canResendOtp
                                        ? _startResendTimer
                                        : null,
                                    child: Text(
                                      'auth_resend_otp_btn'.tr,
                                      style: const TextStyle(
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
                                  labelText: 'auth_new_password_label'.tr,
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
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
                                  labelText: 'auth_confirm_new_password_label'.tr,
                                  prefixIcon:
                                      const Icon(Icons.lock_reset_rounded),
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
        return 'auth_welcome_back'.tr;
      case AuthViewMode.register:
        return 'auth_create_account'.tr;
      case AuthViewMode.forgotPassword:
        return 'auth_forgot_password'.tr;
      case AuthViewMode.otpVerification:
        return 'auth_enter_otp'.tr;
      case AuthViewMode.resetPassword:
        return 'auth_reset_password'.tr;
    }
  }

  String _getSubtitle() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'auth_login_subtitle'.tr;
      case AuthViewMode.register:
        return 'auth_register_subtitle'.tr;
      case AuthViewMode.forgotPassword:
        return 'auth_forgot_password_subtitle'.tr;
      case AuthViewMode.otpVerification:
        return 'auth_otp_subtitle'.tr;
      case AuthViewMode.resetPassword:
        return 'auth_reset_password_subtitle'.tr;
    }
  }

  String _getButtonText() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'auth_sign_in_btn'.tr;
      case AuthViewMode.register:
        return 'auth_create_account_btn'.tr;
      case AuthViewMode.forgotPassword:
        return 'auth_send_verification_btn'.tr;
      case AuthViewMode.otpVerification:
        return 'auth_verify_otp_btn'.tr;
      case AuthViewMode.resetPassword:
        return 'auth_save_new_password_btn'.tr;
    }
  }

  String _getTogglePrompt() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'auth_no_account_prompt'.tr;
      case AuthViewMode.register:
      case AuthViewMode.forgotPassword:
      case AuthViewMode.otpVerification:
      case AuthViewMode.resetPassword:
        return 'auth_have_account_prompt'.tr;
    }
  }

  String _getToggleAction() {
    switch (_viewMode) {
      case AuthViewMode.login:
        return 'auth_sign_up_action'.tr;
      case AuthViewMode.register:
      case AuthViewMode.forgotPassword:
      case AuthViewMode.otpVerification:
      case AuthViewMode.resetPassword:
        return 'auth_sign_in_action'.tr;
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

