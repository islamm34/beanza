import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../app/theme/app_colors.dart';

class PermissionDeniedView extends StatelessWidget {
  final VoidCallback onRequestPermission;
  final VoidCallback onCancel;

  const PermissionDeniedView({
    Key? key,
    required this.onRequestPermission,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.caramel.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 64,
                color: AppColors.caramel,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Camera Access Required',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Camera access is required to scan QR codes and barcodes. Please grant permission to continue.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.getTextMutedColor(Theme.of(context).brightness),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRequestPermission,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Allow Camera'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => openAppSettings(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Open Settings'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
