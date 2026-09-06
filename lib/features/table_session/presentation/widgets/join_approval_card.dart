import 'package:flutter/material.dart';
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
                color: greenColor.withValues(alpha: isDark ? 0.30 : 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.check_rounded,
              size: 46,
              color: greenColor,
            ),
          ),
        );

      case JoinRequestPreviewStatus.rejected:
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: redColor.withValues(alpha: isDark ? 0.18 : 0.12),
            border: Border.all(color: redColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: redColor.withValues(alpha: isDark ? 0.25 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, 4),
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
    String titleEn;
    String titleAr;
    String descEn;
    String descAr;
    Color? titleColor;

    switch (status) {
      case JoinRequestPreviewStatus.pending:
        if (currentMembers.isEmpty) {
          titleEn = 'No active members';
          titleAr = 'لا يوجد أعضاء حاليون';
          descEn = 'No active member is available to approve this request.';
          descAr = 'لا يوجد عضو حالي داخل الترابيزة للموافقة على الطلب.';
        } else {
          titleEn = 'Waiting for someone at the table to approve you';
          titleAr = 'في انتظار موافقة أحد الموجودين على الترابيزة';
          descEn =
              'Someone at the table needs to confirm that you are with them.';
          descAr = 'يجب أن يؤكد أحد الموجودين على الترابيزة أنك معهم.';
        }
        break;

      case JoinRequestPreviewStatus.approved:
        titleEn = "You’re approved!";
        titleAr = 'تمت الموافقة عليك';
        descEn = '$approverName confirmed that you are at Table $tableNumber.';
        descAr = 'أكد $approverName أنك موجود على الترابيزة $tableNumber.';
        titleColor = greenColor;
        break;

      case JoinRequestPreviewStatus.rejected:
        titleEn = 'Request not approved';
        titleAr = 'لم تتم الموافقة على الطلب';
        descEn = 'A table member could not confirm this request.';
        descAr = 'لم يتمكن أحد أعضاء الترابيزة من تأكيد هذا الطلب.';
        titleColor = redColor;
        break;

      case JoinRequestPreviewStatus.expired:
        titleEn = 'Request expired';
        titleAr = 'انتهت صلاحية الطلب';
        descEn = 'No table member responded to the request in time.';
        descAr = 'لم يستجب أي من أعضاء الطاولة للطلب في الوقت المحدد.';
        break;

      case JoinRequestPreviewStatus.cancelled:
        titleEn = 'Request cancelled';
        titleAr = 'تم إلغاء الطلب';
        descEn = 'You cancelled your request to join Table $tableNumber.';
        descAr = 'قمت بإلغاء طلب الانضمام إلى الترابيزة $tableNumber.';
        break;
    }

    return Column(
      children: [
        Text(
          titleEn,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor ?? primaryText,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          titleAr,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: titleColor ?? primaryText,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$descEn\n$descAr',
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
            'remaining',
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
              'No active member is available to approve this request.\nلا يوجد عضو حالي داخل الترابيزة للموافقة على الطلب.',
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
                'Waiting for someone at the table to approve you • في انتظار موافقة أحد الموجودين',
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
                'Approved by $approverName',
                style: TextStyle(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                ),
              ),
              Text(
                'Approved just now • موافقة فورية',
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
