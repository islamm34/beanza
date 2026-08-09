import 'package:flutter/material.dart';
import '../../domain/entities/scan_result_entity.dart';

class ProductScanResultPage extends StatelessWidget {
  final ScanResultEntity scanResult;

  const ProductScanResultPage({
    Key? key,
    required this.scanResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Barcode Scan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_cafe, size: 64),
            const SizedBox(height: 16),
            Text('Product Code: ${scanResult.rawValue}'),
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
