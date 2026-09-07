import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/join_approval_preview_controller.dart';
import '../models/join_request_preview_status.dart';
import '../models/preview_join_request.dart';
import '../models/preview_table_member.dart';
import 'join_request_status_badge.dart';
import 'requester_avatar.dart';

class JoinApprovalBottomSheet extends StatefulWidget {
  final PreviewJoinRequest? request;
  final PreviewTableMember? actingMember;
  final String requesterName;
  final String tableNumber;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onClose;

  const JoinApprovalBottomSheet({
    Key? key,
    this.request,
    this.actingMember,
    this.requesterName = 'Youssef',
    this.tableNumber = '12',
    this.onApprove,
    this.onReject,
    this.onClose,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    PreviewJoinRequest? request,
    PreviewTableMember? actingMember,
    String requesterName = 'Youssef',
    String tableNumber = '12',
    VoidCallback? onApprove,
    VoidCallback? onReject,
    VoidCallback? onClose,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          isDark ? const Color(0xFF111411) : const Color(0xFFFFFDF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => JoinApprovalBottomSheet(
        request: request,
        actingMember: actingMember,
        requesterName: requesterName,
        tableNumber: tableNumber,
        onApprove: onApprove,
        onReject: onReject,
        onClose: onClose,
      ),
    );
  }

  @override
  State<JoinApprovalBottomSheet> createState() =>
      _JoinApprovalBottomSheetState();
}

class _JoinApprovalBottomSheetState extends State<JoinApprovalBottomSheet> {
  late final JoinApprovalPreviewController _controller;
  late PreviewJoinRequest _request;
  late PreviewTableMember _actingMember;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<JoinApprovalPreviewController>()) {
      _controller = Get.find<JoinApprovalPreviewController>();
    } else {
      _controller = Get.put(JoinApprovalPreviewController());
    }

    _request = widget.request ??
        PreviewJoinRequest(
          id: 'req_join_101',
          requesterId: JoinApprovalPreviewController.defaultRequesterId,
          requesterName: widget.requesterName,
          tableSessionId: 'table_${widget.tableNumber}',
          status: JoinRequestPreviewStatus.pending,
        );

    _actingMember = widget.actingMember ?? _controller.actingMember.value;
  }

  bool get _isSelfApproval => _actingMember.id == _request.requesterId;
  bool get _canApprove => _controller.canApproveRequest(
        request: _request,
        actingMember: _actingMember,
      );

  void _handleApprove() {
    final success = _controller.approveRequest(
      request: _request,
      actingMember: _actingMember,
    );

    if (success) {
      Navigator.pop(context);
      widget.onApprove?.call();
    } else {
      // Show failure feedback if validation prevented self-approval
      Get.snackbar(
        'action_not_allowed'.tr,
        'cannot_approve_own_request'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD95656),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _handleReject() {
    final success = _controller.rejectRequest(
      request: _request,
      actingMember: _actingMember,
    );

    if (success) {
      Navigator.pop(context);
      widget.onReject?.call();
    } else {
      Get.snackbar(
        'action_not_allowed'.tr,
        'cannot_reject_own_request'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD95656),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryText =
        isDark ? const Color(0xFFF5F2EA) : const Color(0xFF201611);
    final secondaryText =
        isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63);
    final goldColor =
        isDark ? const Color(0xFFD0932F) : const Color(0xFFB6781E);
    final greenColor =
        isDark ? const Color(0xFF31A93D) : const Color(0xFF278C35);
    final redColor = isDark ? const Color(0xFFD95656) : const Color(0xFFB94343);
    final elevatedCardBg =
        isDark ? const Color(0xFF171A17) : const Color(0xFFEFE8DC);
    final borderColor =
        isDark ? const Color(0xFF2A302A) : const Color(0xFFDED4C5);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // 2. Acting Member Preview Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: goldColor.withValues(alpha: isDark ? 0.16 : 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: goldColor.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    size: 16,
                    color: goldColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'previewing_as'.trParams({'name': _actingMember.name}),
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFFF1B447)
                            : const Color(0xFFB6781E),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (_actingMember.isApproved)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: greenColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'approved_member_badge'.tr,
                        style: TextStyle(
                          color: greenColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 3. Header with Title & Close
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: goldColor.withValues(alpha: isDark ? 0.20 : 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: goldColor.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    color: goldColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'new_join_request_title'.tr,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: secondaryText,
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onClose?.call();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Requester Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: elevatedCardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                children: [
                  RequesterAvatar(
                    name: _request.requesterName,
                    size: 50,
                    showBorder: true,
                    borderColor: goldColor,
                    badgeIcon: Icons.hourglass_top_rounded,
                    badgeColor: goldColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _request.requesterName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            Text(
                              'table_with_num'.trParams({'table': widget.tableNumber}),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: goldColor,
                              ),
                            ),
                            Text(
                              '• ${'just_now'.tr}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const JoinRequestStatusBadge(
                    status: JoinRequestPreviewStatus.pending,
                    compact: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 5. Confirmation Question or Self-Approval Warning
            if (_isSelfApproval)
              Container(
                key: const Key('self_approval_warning_card'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: redColor.withValues(alpha: isDark ? 0.16 : 0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: redColor.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.block_rounded,
                      color: redColor,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'cannot_approve_own_request_title'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: redColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'another_member_must_approve_desc'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: secondaryText,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              )
            else if (!_actingMember.isApproved)
              Container(
                key: const Key('unapproved_member_warning_card'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: goldColor.withValues(alpha: isDark ? 0.16 : 0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: goldColor.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: goldColor,
                      size: 26,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'only_approved_members_can_approve'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: goldColor.withValues(alpha: isDark ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: goldColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'is_requester_with_you'.trParams({'name': _request.requesterName}),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'only_approve_recognized_person'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: secondaryText,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 22),

            // 6. Action Buttons (Only enabled when acting member is allowed)
            if (_canApprove)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        key: const Key('reject_join_request_button'),
                        onPressed: _handleReject,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: redColor.withValues(alpha: 0.6),
                            width: 1.4,
                          ),
                          foregroundColor: redColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.close_rounded, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'reject_btn'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        key: const Key('approve_join_request_button'),
                        onPressed: _handleApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded,
                                  size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'approve_btn'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // 7. Debug-Only Acting Member Switcher
            if (kDebugMode) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF080B09)
                      : const Color(0xFFF6F1E7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug: Switch Acting Member',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildMemberChip(
                            label: 'Ahmed (Approved)',
                            member: JoinApprovalPreviewController.memberAhmed,
                            goldColor: goldColor,
                          ),
                          const SizedBox(width: 6),
                          _buildMemberChip(
                            label: 'Sara (Approved)',
                            member: JoinApprovalPreviewController.memberSara,
                            goldColor: goldColor,
                          ),
                          const SizedBox(width: 6),
                          _buildMemberChip(
                            label: 'Mostafa (Approved)',
                            member: JoinApprovalPreviewController.memberMostafa,
                            goldColor: goldColor,
                          ),
                          const SizedBox(width: 6),
                          _buildMemberChip(
                            label: 'Youssef (Requester)',
                            member:
                                JoinApprovalPreviewController.requesterAsMember,
                            goldColor: redColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMemberChip({
    required String label,
    required PreviewTableMember member,
    required Color goldColor,
  }) {
    final isSelected = _actingMember.id == member.id;

    return InkWell(
      key: Key('switch_acting_member_${member.id}'),
      onTap: () {
        setState(() {
          _actingMember = member;
          _controller.setActingMember(member);
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? goldColor : goldColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? goldColor : goldColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : goldColor,
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
