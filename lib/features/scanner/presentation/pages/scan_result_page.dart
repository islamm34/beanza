import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/scan_result_entity.dart';

class ScanResultPage extends StatelessWidget {
  final ScanResultEntity scanResult;

  const ScanResultPage({
    Key? key,
    required this.scanResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.caramel.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  scanResult.scanType == ScanType.qr
                      ? Icons.qr_code_2_rounded
                      : Icons.qr_code_scanner_rounded,
                  size: 64,
                  color: AppColors.caramel,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              scanResult.scanType == ScanType.qr
                  ? 'QR Code Detected'
                  : 'Barcode Detected',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkSecondaryBg : AppColors.softSand,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(context, 'Format', scanResult.barcodeFormat),
                  const Divider(height: 24),
                  _buildDetailRow(context, 'Type', scanResult.scanType.name.toUpperCase()),
                  const Divider(height: 24),
                  _buildDetailRow(context, 'Scanned At', _formatTimestamp(scanResult.timestamp)),
                  const Divider(height: 24),
                  Text(
                    'Raw Value',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.getTextMutedColor(Theme.of(context).brightness),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    scanResult.rawValue,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // true indicates scan again
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Scan Again'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.getTextMutedColor(Theme.of(context).brightness),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}
