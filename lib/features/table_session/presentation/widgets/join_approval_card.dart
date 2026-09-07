import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/join_request_preview_status.dart';
import 'requester_avatar.dart';
import 'waiting_approval_indicator.dart';

class JoinApprovalCard extends StatelessWidget {
  final JoinRequestPreviewStatus status;
  final String tableNumber;
  final String countdownText;
  final String requesterName;
  final String approverName;
  final List<String> currentMembers;

  const JoinApprovalCard({
    Key? key,
    required this.status,
    required this.tableNumber,
    this.countdownText = '01:45',
    this.requesterName = 'Youssef',
    this.approverName = 'Ahmed',
    this.currentMembers = const ['Ahmed', 'Sara', 'Mostafa'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF111411) : const Color(0xFFFFFDF8);
    final borderColor =
        isDark ? const Color(0xFF2A302A) : const Color(0xFFDED4C5);
    final primaryText =
        isDark ? const Color(0xFFF5F2EA) : const Color(0xFF201611);
    final secondaryText =
        isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63);
    final goldColor =
        isDark ? const Color(0xFFD0932F) : const Color(0xFFB6781E);
    final greenColor =
        isDark ? const Color(0xFF31A93D) : const Color(0xFF278C35);
    final redColor = isDark ? const Color(0xFFD95656) : const Color(0xFFB94343);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCenterGraphic(isDark, goldColor, greenColor, redColor),
          const SizedBox(height: 18),
          _buildTitleAndMessage(
              isDark, primaryText, secondaryText, greenColor, redColor),
          const SizedBox(height: 16),
          if (status == JoinRequestPreviewStatus.pending) ...[
            _buildCountdownChip(isDark, goldColor, secondaryText),
            const SizedBox(height: 22),
            _buildCurrentMembersSection(
                isDark, primaryText, secondaryText, goldColor),
          ] else if (status == JoinRequestPreviewStatus.approved) ...[
            _buildApproverInfo(isDark, primaryText, secondaryText, greenColor),
          ],
        ],
      ),
    );
  }

  Widget _buildCenterGraphic(
    bool isDark,
    Color goldColor,
    Color greenColor,
    Color redColor,
  ) {
    switch (status) {
      case JoinRequestPreviewStatus.pending:
        return const WaitingApprovalIndicator(
          size: 100,
          icon: Icons.local_cafe_rounded,
        );

      case JoinRequestPreviewStatus.approved:
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: greenColor.withValues(alpha: isDark ? 0.20 : 0.14),
            border: Border.all(color: greenColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: greenColor.withValues(alpha: 0.3),
                blurRadius: 14,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        );

      case JoinRequestPreviewStatus.rejected:
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: redColor.withValues(alpha: isDark ? 0.20 : 0.14),
            border: Border.all(color: redColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: redColor.withValues(alpha: 0.3),
                blurRadius: 14,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.close_rounded,
              size: 44,
              color: redColor,
            ),
          ),
        );

      case JoinRequestPreviewStatus.expired:
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: goldColor.withValues(alpha: isDark ? 0.16 : 0.10),
            border:
                Border.all(color: goldColor.withValues(alpha: 0.6), width: 2),
          ),
          child: Center(
            child: Icon(
              Icons.timer_off_outlined,
              size: 42,
              color: goldColor,
            ),
          ),
        );

      case JoinRequestPreviewStatus.cancelled:
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
            border: Border.all(
              color:
                  (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.do_not_disturb_on_outlined,
            size: 42,
            color: isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63),
          ),
        );
    }
  }

  Widget _buildTitleAndMessage(
    bool isDark,
    Color primaryText,
    Color secondaryText,
    Color greenColor,
    Color redColor,
  ) {
    String title;
    String desc;
    Color? titleColor;

    switch (status) {
      case JoinRequestPreviewStatus.pending:
        if (currentMembers.isEmpty) {
          title = 'no_active_members_title'.tr;
          desc = 'no_active_members_desc'.tr;
        } else {
          title = 'waiting_for_approval_card_title'.tr;
          desc = 'waiting_for_approval_card_desc'.tr;
        }
        break;

      case JoinRequestPreviewStatus.approved:
        title = 'youre_approved_title'.tr;
        desc = 'approved_by_desc'
            .trParams({'name': approverName, 'table': tableNumber});
        titleColor = greenColor;
        break;

      case JoinRequestPreviewStatus.rejected:
        title = 'request_not_approved_title'.tr;
        desc = 'request_not_approved_desc'.tr;
        titleColor = redColor;
        break;

      case JoinRequestPreviewStatus.expired:
        title = 'request_expired_title'.tr;
        desc = 'request_expired_desc'.tr;
        break;

      case JoinRequestPreviewStatus.cancelled:
        title = 'request_cancelled_title'.tr;
        desc = 'request_cancelled_desc'.trParams({'table': tableNumber});
        break;
    }

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor ?? primaryText,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownChip(
    bool isDark,
    Color goldColor,
    Color secondaryText,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: goldColor.withValues(alpha: isDark ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goldColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: goldColor),
          const SizedBox(width: 6),
          Text(
            countdownText,
            style: TextStyle(
              color: goldColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'remaining'.tr,
            style: TextStyle(
              color: secondaryText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentMembersSection(
    bool isDark,
    Color primaryText,
    Color secondaryText,
    Color goldColor,
  ) {
    if (currentMembers.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            Icon(Icons.people_outline_rounded, size: 28, color: goldColor),
            const SizedBox(height: 6),
            Text(
              'no_active_member_available'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    isDark ? const Color(0xFFF1B447) : const Color(0xFFB6781E),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: goldColor,
                boxShadow: [
                  BoxShadow(
                    color: goldColor.withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'waiting_for_table_approval_banner'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFF1B447)
                      : const Color(0xFFB6781E),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: currentMembers.map((member) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RequesterAvatar(
                  name: member,
                  size: 46,
                  showBorder: true,
                  borderColor: goldColor.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 5),
                Text(
                  member,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApproverInfo(
    bool isDark,
    Color primaryText,
    Color secondaryText,
    Color greenColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: greenColor.withValues(alpha: isDark ? 0.15 : 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greenColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RequesterAvatar(
            name: approverName,
            size: 34,
            showBorder: true,
            borderColor: greenColor,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'approved_by'.trParams({'name': approverName}),
                style: TextStyle(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                ),
              ),
              Text(
                'approved_just_now'.tr,
                style: TextStyle(
                  color: greenColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
