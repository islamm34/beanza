import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/join_request_preview_status.dart';

// Design preview controls for prototype evaluation only.
// Rendered only in kDebugMode and never shown in release mode.
class JoinRequestPreviewControls extends StatelessWidget {
  final JoinRequestPreviewStatus currentStatus;
  final ValueChanged<JoinRequestPreviewStatus> onStatusChanged;
  final VoidCallback? onTriggerIncomingModal;

  const JoinRequestPreviewControls({
    Key? key,
    required this.currentStatus,
    required this.onStatusChanged,
    this.onTriggerIncomingModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor =
        isDark ? const Color(0xFFD0932F) : const Color(0xFFB6781E);
    final cardBg = isDark ? const Color(0xFF171A17) : const Color(0xFFEFE8DC);
    final borderColor =
        isDark ? const Color(0xFF2A302A) : const Color(0xFFDED4C5);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.developer_mode_rounded, size: 14, color: goldColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Prototype UI Preview Controls (Debug Only)',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: goldColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildStatusChip(
                  label: 'Pending',
                  status: JoinRequestPreviewStatus.pending,
                  isDark: isDark,
                  goldColor: goldColor,
                ),
                const SizedBox(width: 6),
                _buildStatusChip(
                  label: 'Approved',
                  status: JoinRequestPreviewStatus.approved,
                  isDark: isDark,
                  goldColor: const Color(0xFF31A93D),
                ),
                const SizedBox(width: 6),
                _buildStatusChip(
                  label: 'Rejected',
                  status: JoinRequestPreviewStatus.rejected,
                  isDark: isDark,
                  goldColor: const Color(0xFFD95656),
                ),
                const SizedBox(width: 6),
                _buildStatusChip(
                  label: 'Expired',
                  status: JoinRequestPreviewStatus.expired,
                  isDark: isDark,
                  goldColor: const Color(0xFFA6A69F),
                ),
                const SizedBox(width: 6),
                _buildStatusChip(
                  label: 'Cancelled',
                  status: JoinRequestPreviewStatus.cancelled,
                  isDark: isDark,
                  goldColor: const Color(0xFFA6A69F),
                ),
                if (onTriggerIncomingModal != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    height: 20,
                    width: 1,
                    color: borderColor,
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    key: const Key('preview_incoming_modal_button'),
                    onTap: onTriggerIncomingModal,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: goldColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: goldColor.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.open_in_new_rounded,
                              size: 12, color: goldColor),
                          const SizedBox(width: 4),
                          Text(
                            'Incoming Sheet',
                            style: TextStyle(
                              color: goldColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required JoinRequestPreviewStatus status,
    required bool isDark,
    required Color goldColor,
  }) {
    final isSelected = currentStatus == status;

    return InkWell(
      key: Key('preview_status_chip_${status.name}'),
      onTap: () => onStatusChanged(status),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? goldColor
              : goldColor.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? goldColor : goldColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFFF5F2EA) : const Color(0xFF201611)),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
