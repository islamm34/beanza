import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/scan_history_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/scan_record_model.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/empty_state.dart';

class ScanHistoryPage extends StatelessWidget {
  const ScanHistoryPage({Key? key}) : super(key: key);

  void _confirmClearAll(
      BuildContext context, ScanHistoryController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear Scan History?',
          style: TextStyle(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all your saved scans?',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: const Key('confirm_clear_history'),
            onPressed: () {
              controller.clearHistory();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanHistoryController = Get.isRegistered<ScanHistoryController>()
        ? Get.find<ScanHistoryController>()
        : Get.put(ScanHistoryController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'Scan History / سجل المسح',
        showCartAction: false,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_rounded, color: goldColor),
            tooltip: 'Clear History',
            onPressed: () => _confirmClearAll(context, scanHistoryController),
          ),
        ],
      ),
      body: Obx(() {
        final records = scanHistoryController.scanHistory;

        if (records.isEmpty) {
          return const EmptyState(
            icon: Icons.qr_code_scanner_rounded,
            title: 'No Scans Yet',
            description:
                'Your scanned tables, orders, and café codes will appear here.',
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return ScanHistoryTile(
              record: record,
              onDelete: () => scanHistoryController.removeScanRecord(record.id),
            );
          },
        );
      }),
    );
  }
}

class ScanHistoryTile extends StatelessWidget {
  final ScanRecord record;
  final VoidCallback onDelete;

  const ScanHistoryTile({
    required this.record,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  IconData _getIcon() {
    switch (record.type.toLowerCase()) {
      case 'table':
        return Icons.table_restaurant_rounded;
      case 'order':
        return Icons.receipt_long_rounded;
      case 'product':
        return Icons.local_cafe_rounded;
      default:
        return Icons.qr_code_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: goldColor.withValues(alpha: isDark ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(),
                color: goldColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.type.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.rawValue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')} - ${record.format}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                          : AppColors.lightTextSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 20, color: AppColors.error),
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
