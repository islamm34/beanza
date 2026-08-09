import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/features/scanner/domain/entities/scan_result_entity.dart';

void main() {
  group('ScanResultEntity & Classification', () {
    test('classifies QR code formats correctly', () {
      expect(
        ScanResultEntity.classifyType('qrCode', 'https://caffeine.co'),
        ScanType.qr,
      );
      expect(
        ScanResultEntity.classifyType('aztec', '12345'),
        ScanType.qr,
      );
      expect(
        ScanResultEntity.classifyType('dataMatrix', 'DATA_123'),
        ScanType.qr,
      );
    });

    test('classifies barcode formats correctly', () {
      expect(
        ScanResultEntity.classifyType('code128', '8901234567890'),
        ScanType.barcode,
      );
      expect(
        ScanResultEntity.classifyType('ean13', '5901234123457'),
        ScanType.barcode,
      );
      expect(
        ScanResultEntity.classifyType('upcA', '012345678905'),
        ScanType.barcode,
      );
    });

    test('classifies empty or unknown scan values as unknown', () {
      expect(
        ScanResultEntity.classifyType('qrCode', ''),
        ScanType.unknown,
      );
      expect(
        ScanResultEntity.classifyType('customFormat', 'XYZ'),
        ScanType.unknown,
      );
    });

    test('supports value equality', () {
      final now = DateTime(2026, 8, 9);
      final result1 = ScanResultEntity(
        rawValue: '12345678',
        barcodeFormat: 'code128',
        scanType: ScanType.barcode,
        timestamp: now,
      );

      final result2 = ScanResultEntity(
        rawValue: '12345678',
        barcodeFormat: 'code128',
        scanType: ScanType.barcode,
        timestamp: now,
      );

      expect(result1, equals(result2));
    });
  });
}
