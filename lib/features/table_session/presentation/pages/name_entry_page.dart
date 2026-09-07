import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/adaptive_cafe_logo.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../controllers/join_approval_preview_controller.dart';
import '../models/table_occupancy_state.dart';

class NameEntryPage extends StatefulWidget {
  const NameEntryPage({Key? key}) : super(key: key);

  @override
  State<NameEntryPage> createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late final JoinApprovalPreviewController _controller;
  late String tableId;
  late String tableNumber;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<JoinApprovalPreviewController>()) {
      _controller = Get.find<JoinApprovalPreviewController>();
    } else {
      _controller = Get.put(JoinApprovalPreviewController());
    }

    final args = Get.arguments as Map<String, dynamic>?;
    tableId = args?['tableId'] as String? ?? '12';
    tableNumber = args?['tableNumber'] as String? ?? '12';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitName() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final name = _nameController.text.trim();

    await _controller.continueAfterNameEntry(
      name: name,
      tableId: tableId,
      tableNumber: tableNumber,
      onDirectJoin: () {
        Get.snackbar(
          'table_session_started'.tr,
          'first_member_toast'.trParams({'table': tableNumber}),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF31A93D),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(Routes.TABLE_OVERVIEW);
      },
      onWaitingApproval: () {
        Get.toNamed(
          Routes.WAITING_APPROVAL,
          arguments: {
            'tableId': tableId,
            'tableNumber': tableNumber,
            'participantName': name,
          },
        );
      },
      onError: (msg) {
        Get.snackbar(
          'error'.tr,
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD95656),
          colorText: Colors.white,
        );
      },
    );
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
                    'table_badge'.trParams({'table': tableNumber}),
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
                  'join_table_session_title'.tr,
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
                  'join_table_subtitle'.tr,
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
                            labelText: 'your_name_label'.tr,
                            hintText: 'your_name_hint'.tr,
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: goldColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'name_required_error'.tr;
                            }
                            if (value.trim().length < 2) {
                              return 'name_min_chars_error'.tr;
                            }
                            if (value.trim().length > 20) {
                              return 'name_max_chars_error'.tr;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submitName(),
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          final isChecking =
                              _controller.isCheckingTable.value ||
                                  _controller.isSubmitting.value;
                          final isError =
                              _controller.tableOccupancyState.value ==
                                  TableOccupancyState.error;

                          return Column(
                            children: [
                              if (isChecking) ...[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  goldColor),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'checking_table_status'.trParams(
                                              {'table': tableNumber}),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: goldColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (isError && !isChecking) ...[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline_rounded,
                                          color: Color(0xFFD95656), size: 16),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'checking_table_error'.tr,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFFD95656),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              PrimaryButton(
                                key: const Key('join_table_continue_button'),
                                isLoading: isChecking,
                                isEnabled: !isChecking,
                                label: isChecking
                                    ? 'checking_table_status'.trParams(
                                        {'table': tableNumber})
                                    : (isError
                                        ? 'retry_table_check'.tr
                                        : 'join_table_button'.tr),
                                onPressed: _submitName,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Debug occupancy preview switcher
                if (kDebugMode) ...[
                  _buildDebugOccupancyControls(isDark: isDark),
                  const SizedBox(height: 12),
                ],

                TextButton.icon(
                  onPressed: () => Get.offAllNamed(Routes.SCANNER),
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 18,
                    color: goldColor,
                  ),
                  label: Text(
                    'scan_another_table'.tr,
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

  Widget _buildDebugOccupancyControls({required bool isDark}) {
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final cardBg = isDark ? const Color(0xFF171A17) : const Color(0xFFEFE8DC);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: goldColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 12, color: goldColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Debug Table Simulation',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildDebugButton(
                  label: 'Empty',
                  keyName: 'debug_occupancy_empty',
                  onTap: () {
                    _controller.clearPreviewTable();
                    _controller
                        .setForcedDebugOccupancy(TableOccupancyState.empty);
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDebugButton(
                  label: 'Occupied',
                  keyName: 'debug_occupancy_occupied',
                  onTap: () {
                    _controller.seedOccupiedTableForPreview();
                    _controller
                        .setForcedDebugOccupancy(TableOccupancyState.occupied);
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildDebugButton(
                  label: 'Error',
                  keyName: 'debug_occupancy_error',
                  onTap: () {
                    _controller
                        .setForcedDebugOccupancy(TableOccupancyState.error);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebugButton({
    required String label,
    required String keyName,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: Key(keyName),
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
