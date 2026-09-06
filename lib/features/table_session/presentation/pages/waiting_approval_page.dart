import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../controllers/join_approval_preview_controller.dart';
import '../models/join_request_preview_status.dart';
import '../widgets/join_approval_card.dart';
import '../widgets/join_request_status_badge.dart';
import '../widgets/requester_avatar.dart';

class WaitingApprovalPage extends StatefulWidget {
  final String? initialTableNumber;
  final String? initialRequesterName;
  final JoinRequestPreviewStatus? initialStatus;
  final List<String>? initialMembers;

  const WaitingApprovalPage({
    Key? key,
    this.initialTableNumber,
    this.initialRequesterName,
    this.initialStatus,
    this.initialMembers,
  }) : super(key: key);

  @override
  State<WaitingApprovalPage> createState() => _WaitingApprovalPageState();
}

class _WaitingApprovalPageState extends State<WaitingApprovalPage> {
  late final JoinApprovalPreviewController _controller;
  late String tableId;
  late String tableNumber;
  late String participantName;

  Timer? _countdownTimer;
  int _secondsRemaining = 105; // 01:45 initial countdown
  List<String> _currentMembers = ['Ahmed', 'Sara', 'Mostafa'];

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
    tableNumber =
        widget.initialTableNumber ?? args?['tableNumber'] as String? ?? '12';
    participantName = widget.initialRequesterName ??
        args?['participantName'] as String? ??
        'Youssef';

    if (widget.initialMembers != null) {
      _currentMembers = widget.initialMembers!;
    }

    _controller.initRequest(
      tableNumber: tableNumber,
      requesterName: participantName,
      initialStatus: widget.initialStatus,
    );

    if (_controller.status == JoinRequestPreviewStatus.pending) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_controller.status != JoinRequestPreviewStatus.pending) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        _controller.expireRequest();
      }
    });
  }

  String get _formattedCountdown {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _resetToPending() {
    setState(() {
      _secondsRemaining = 105;
    });
    _controller.resetToPending();
    _startCountdown();
  }

  void _showCancelConfirmation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF111411) : const Color(0xFFFFFDF8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Cancel Request? / إلغاء الطلب؟',
            style: TextStyle(
              color: isDark ? const Color(0xFFF5F2EA) : const Color(0xFF201611),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel your request to join Table $tableNumber?\n\nهل أنت متأكد من رغبتك في إلغاء طلب الانضمام إلى الترابيزة $tableNumber؟',
            style: TextStyle(
              color: isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63),
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Keep Waiting'),
            ),
            ElevatedButton(
              key: const Key('confirm_cancel_request_button'),
              onPressed: () {
                Navigator.pop(ctx);
                _countdownTimer?.cancel();
                _controller.cancelRequest();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD95656),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel Request'),
            ),
          ],
        );
      },
    );
  }

  void _handleEnterTable() {
    if (Get.isRegistered<TableSessionController>()) {
      final controller = Get.find<TableSessionController>();
      controller.joinTableSession(
        tableId: tableId,
        tableNumber: tableNumber,
        participantName: participantName,
      );
    }
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF080B09) : const Color(0xFFF6F1E7);
    final primaryText =
        isDark ? const Color(0xFFF5F2EA) : const Color(0xFF201611);
    final secondaryText =
        isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63);
    final goldColor =
        isDark ? const Color(0xFFD0932F) : const Color(0xFFB6781E);
    final greenColor =
        isDark ? const Color(0xFF31A93D) : const Color(0xFF278C35);
    final redColor = isDark ? const Color(0xFFD95656) : const Color(0xFFB94343);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Obx(() {
          final request = _controller.currentRequest.value;
          final status = request.status;
          final approvedList = _currentMembers;

          return Column(
            children: [
              // 1. Top Bar: Back Action & Centered Table Chip
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      key: const Key('waiting_approval_back_button'),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: primaryText,
                        size: 20,
                      ),
                      onPressed: () {
                        if (status == JoinRequestPreviewStatus.pending) {
                          _showCancelConfirmation();
                        } else {
                          Get.back();
                        }
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: goldColor.withValues(
                                  alpha: isDark ? 0.18 : 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: goldColor.withValues(alpha: 0.6),
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              'Table $tableNumber • الترابيزة $tableNumber',
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFF1B447)
                                    : const Color(0xFFB6781E),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 48), // Balances the leading IconButton
                  ],
                ),
              ),

              // 2. Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Requester Section (Avatar + Name + Status Badge)
                      RequesterAvatar(
                        name: participantName,
                        size: 78,
                        showBorder: true,
                        borderColor: status == JoinRequestPreviewStatus.approved
                            ? greenColor
                            : (status == JoinRequestPreviewStatus.rejected
                                ? redColor
                                : goldColor),
                        badgeIcon: status == JoinRequestPreviewStatus.approved
                            ? Icons.check_rounded
                            : (status == JoinRequestPreviewStatus.rejected
                                ? Icons.close_rounded
                                : Icons.hourglass_top_rounded),
                        badgeColor: status == JoinRequestPreviewStatus.approved
                            ? greenColor
                            : (status == JoinRequestPreviewStatus.rejected
                                ? redColor
                                : goldColor),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        participantName,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      JoinRequestStatusBadge(status: status),
                      const SizedBox(height: 24),

                      // Main Approval Card
                      JoinApprovalCard(
                        status: status,
                        tableNumber: tableNumber,
                        countdownText: _formattedCountdown,
                        requesterName: participantName,
                        approverName: 'Ahmed',
                        currentMembers: approvedList,
                      ),
                      const SizedBox(height: 28),

                      // Action Buttons depending on status (Requester NEVER sees Approve or Reject)
                      _buildRequesterActions(
                        status: status,
                        isDark: isDark,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        greenColor: greenColor,
                        redColor: redColor,
                        goldColor: goldColor,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRequesterActions({
    required JoinRequestPreviewStatus status,
    required bool isDark,
    required Color primaryText,
    required Color secondaryText,
    required Color greenColor,
    required Color redColor,
    required Color goldColor,
  }) {
    switch (status) {
      case JoinRequestPreviewStatus.pending:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                key: const Key('cancel_join_request_button'),
                onPressed: _showCancelConfirmation,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: redColor.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  foregroundColor: redColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Cancel Request / إلغاء الطلب',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              key: const Key('scan_another_table_button'),
              onPressed: () => Get.offAllNamed(Routes.SCANNER),
              icon: Icon(Icons.qr_code_scanner_rounded,
                  size: 16, color: goldColor),
              label: Text(
                'Scan Another Table / مسح طاولة أخرى',
                style: TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );

      case JoinRequestPreviewStatus.approved:
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            key: const Key('enter_table_button'),
            onPressed: _handleEnterTable,
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login_rounded, size: 20),
                SizedBox(width: 8),
                Text(
                  'Enter Table / دخول الترابيزة',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );

      case JoinRequestPreviewStatus.rejected:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                key: const Key('try_again_button'),
                onPressed: _resetToPending,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: AppColors.espressoDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Try Again / المحاولة مرة أخرى',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Get.offAllNamed(Routes.SCANNER),
              icon: Icon(Icons.qr_code_scanner_rounded,
                  size: 16, color: secondaryText),
              label: Text(
                'Scan Another Table / مسح طاولة أخرى',
                style: TextStyle(
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );

      case JoinRequestPreviewStatus.expired:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                key: const Key('send_again_button'),
                onPressed: _resetToPending,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: AppColors.espressoDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Send Again / إعادة الإرسال',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Get.offAllNamed(Routes.SCANNER),
              icon: Icon(Icons.qr_code_scanner_rounded,
                  size: 16, color: secondaryText),
              label: Text(
                'Scan Another Table / مسح طاولة أخرى',
                style: TextStyle(
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );

      case JoinRequestPreviewStatus.cancelled:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                key: const Key('request_again_button'),
                onPressed: _resetToPending,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: AppColors.espressoDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Request Again / طلب الانضمام مجدداً',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Get.offAllNamed(Routes.SCANNER),
              icon: Icon(Icons.qr_code_scanner_rounded,
                  size: 16, color: secondaryText),
              label: Text(
                'Scan Another Table / مسح طاولة أخرى',
                style: TextStyle(
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );
    }
  }
}
