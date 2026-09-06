import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../../../../core/widgets/common/adaptive_cafe_logo.dart';

class NameEntryPage extends StatefulWidget {
  const NameEntryPage({Key? key}) : super(key: key);

  @override
  State<NameEntryPage> createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late String tableId;
  late String tableNumber;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    tableId = args?['tableId'] as String? ?? '12';
    tableNumber = args?['tableNumber'] as String? ?? '12';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitName() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();

      Get.toNamed(
        Routes.WAITING_APPROVAL,
        arguments: {
          'tableId': tableId,
          'tableNumber': tableNumber,
          'participantName': name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                const AdaptiveCafeLogo(size: 96, semanticsLabel: 'Cafe Logo'),
                const SizedBox(height: 20),

                // Table Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: goldColor.withValues(alpha: isDark ? 0.18 : 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: goldColor, width: 1.2),
                  ),
                  child: Text(
                    'TABLE $tableNumber • طاولة $tableNumber',
                    style: TextStyle(
                      color: isDark ? AppColors.goldBright : goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  'Join Table Session',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your name to connect with your table members',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 28),

                // Input Card
                CafeCard(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Your Name / اسمك',
                            hintText: 'e.g. Karim',
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: goldColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            if (value.trim().length > 20) {
                              return 'Name cannot exceed 20 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submitName(),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          label: 'Join Table Session ☕',
                          onPressed: _submitName,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton.icon(
                  onPressed: () => Get.offAllNamed(Routes.SCANNER),
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 18,
                    color: goldColor,
                  ),
                  label: Text(
                    'Scan Different Table QR',
                    style: TextStyle(
                      color: goldColor,
                      fontWeight: FontWeight.bold,
                    ),
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
