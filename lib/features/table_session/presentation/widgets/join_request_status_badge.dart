import 'package:flutter/material.dart';
import '../models/join_request_preview_status.dart';

class JoinRequestStatusBadge extends StatelessWidget {
  final JoinRequestPreviewStatus status;
  final bool compact;

  const JoinRequestStatusBadge({
    Key? key,
    required this.status,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color fgColor;
    Color bgColor;
    Color borderColor;
    String labelEn;
    String labelAr;
    IconData icon;

    switch (status) {
      case JoinRequestPreviewStatus.pending:
        fgColor = isDark ? const Color(0xFFF1B447) : const Color(0xFFB6781E);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        labelEn = 'Pending Approval';
        labelAr = 'في انتظار الموافقة';
        icon = Icons.hourglass_top_rounded;
        break;
      case JoinRequestPreviewStatus.approved:
        fgColor = isDark ? const Color(0xFF55C948) : const Color(0xFF278C35);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        labelEn = 'Approved';
        labelAr = 'تمت الموافقة';
        icon = Icons.check_circle_outline_rounded;
        break;
      case JoinRequestPreviewStatus.rejected:
        fgColor = isDark ? const Color(0xFFD95656) : const Color(0xFFB94343);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        labelEn = 'Not Approved';
        labelAr = 'لم تتم الموافقة';
        icon = Icons.cancel_outlined;
        break;
      case JoinRequestPreviewStatus.expired:
        fgColor = isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        labelEn = 'Request Expired';
        labelAr = 'انتهت الصلاحية';
        icon = Icons.timer_off_outlined;
        break;
      case JoinRequestPreviewStatus.cancelled:
        fgColor = isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        labelEn = 'Request Cancelled';
        labelAr = 'تم إلغاء الطلب';
        icon = Icons.remove_circle_outline_rounded;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: fgColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              compact ? labelEn : '$labelEn • $labelAr',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fgColor,
                fontWeight: FontWeight.bold,
                fontSize: compact ? 11 : 11.5,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
