import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class SendTableOrderButton extends StatelessWidget {
  final int totalItems;
  final bool isLoading;
  final bool isSubmitted;
  final bool allParticipantsDone;
  final String readinessMessage;
  final VoidCallback? onPressed;

  const SendTableOrderButton({
    Key? key,
    required this.totalItems,
    this.isLoading = false,
    this.isSubmitted = false,
    this.allParticipantsDone = false,
    required this.readinessMessage,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // After successful submission, replace button with non-interactive success card
    if (isSubmitted) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141210) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF00D98B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00D98B).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00D98B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Order Sent to Barista',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00D98B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'تم إرسال الطلب للباريستا • In Preparation (قيد التحضير)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isEnabled = allParticipantsDone &&
        totalItems > 0 &&
        !isLoading &&
        onPressed != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0A08) : AppColors.lightBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Table Readiness Status Line above CTA
            if (readinessMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      allParticipantsDone
                          ? Icons.check_circle_rounded
                          : Icons.hourglass_top_rounded,
                      size: 14,
                      color: allParticipantsDone
                          ? const Color(0xFF00D98B)
                          : AppColors.caramel,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      readinessMessage,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: allParticipantsDone
                            ? const Color(0xFF00D98B)
                            : AppColors.caramel,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isEnabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.caramel,
                  disabledBackgroundColor:
                      isDark ? const Color(0xFF2B2420) : Colors.grey.shade400,
                  foregroundColor: AppColors.espressoDark,
                  disabledForegroundColor: isDark
                      ? AppColors.textLightMuted.withValues(alpha: 0.5)
                      : Colors.grey.shade700,
                  elevation: isEnabled ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(AppColors.espressoDark),
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isEnabled
                                    ? Icons.send_rounded
                                    : Icons.lock_outline_rounded,
                                size: 20,
                                color: isEnabled
                                    ? AppColors.espressoDark
                                    : (isDark
                                        ? AppColors.textLightMuted
                                        : Colors.grey.shade700),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEnabled
                                        ? 'Send Combined Table Order to Barista'
                                        : 'Waiting for Everyone',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isEnabled
                                          ? AppColors.espressoDark
                                          : (isDark
                                              ? AppColors.textLight
                                              : Colors.grey.shade800),
                                    ),
                                  ),
                                  Text(
                                    isEnabled
                                        ? 'إرسال طلب الطاولة للباريستا'
                                        : 'في انتظار باقي الضيوف لتأكيد الطلب',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: isEnabled
                                          ? AppColors.espressoDark
                                              .withValues(alpha: 0.8)
                                          : (isDark
                                              ? AppColors.textLightMuted
                                              : Colors.grey.shade600),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isEnabled
                                  ? AppColors.espressoDark
                                      .withValues(alpha: 0.15)
                                  : (isDark
                                      ? Colors.black.withValues(alpha: 0.3)
                                      : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$totalItems items',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isEnabled
                                    ? AppColors.espressoDark
                                    : (isDark
                                        ? AppColors.textLightMuted
                                        : Colors.grey.shade800),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
