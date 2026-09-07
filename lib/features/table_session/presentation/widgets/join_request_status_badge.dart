import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    String label;
    IconData icon;

    switch (status) {
      case JoinRequestPreviewStatus.pending:
        fgColor = isDark ? const Color(0xFFF1B447) : const Color(0xFFB6781E);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        label = 'badge_pending_approval'.tr;
        icon = Icons.hourglass_top_rounded;
        break;
      case JoinRequestPreviewStatus.approved:
        fgColor = isDark ? const Color(0xFF55C948) : const Color(0xFF278C35);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        label = 'badge_approved'.tr;
        icon = Icons.check_circle_outline_rounded;
        break;
      case JoinRequestPreviewStatus.rejected:
        fgColor = isDark ? const Color(0xFFD95656) : const Color(0xFFB94343);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        label = 'badge_rejected'.tr;
        icon = Icons.cancel_outlined;
        break;
      case JoinRequestPreviewStatus.expired:
        fgColor = isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        label = 'badge_expired'.tr;
        icon = Icons.timer_off_outlined;
        break;
      case JoinRequestPreviewStatus.cancelled:
        fgColor = isDark ? const Color(0xFFA6A69F) : const Color(0xFF746B63);
        bgColor = fgColor.withValues(alpha: isDark ? 0.18 : 0.12);
        borderColor = fgColor.withValues(alpha: 0.5);
        label = 'badge_cancelled'.tr;
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
              label,
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
