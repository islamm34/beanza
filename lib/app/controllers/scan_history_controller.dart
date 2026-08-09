import 'package:get/get.dart';
import '../../core/models/scan_record_model.dart';

class ScanHistoryController extends GetxController {
  final scanHistory = <ScanRecord>[].obs;

  void addScanRecord(String rawValue, String format, String type) {
    final record = ScanRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      rawValue: rawValue,
      format: format,
      type: type,
      timestamp: DateTime.now(),
    );
    scanHistory.insert(0, record);
  }

  void removeScanRecord(String id) {
    scanHistory.removeWhere((r) => r.id == id);
  }

  void clearHistory() {
    scanHistory.clear();
  }
}
