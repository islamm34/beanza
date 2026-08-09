import 'package:flutter/material.dart';
import '../../domain/entities/scan_result_entity.dart';

class CafeScanResultPage extends StatelessWidget {
  final ScanResultEntity scanResult;

  const CafeScanResultPage({
    Key? key,
    required this.scanResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe Scan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, size: 64),
            const SizedBox(height: 16),
            Text('Cafe QR Value: ${scanResult.rawValue}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Scan Again'),
            ),
          ],
        ),
      ),
    );
  }
}
