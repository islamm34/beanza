import '../entities/scan_history_entity.dart';
import '../repositories/scan_history_repository.dart';

class GetScanHistoryUsecase {
  final ScanHistoryRepository repository;

  GetScanHistoryUsecase({required this.repository});

  Future<List<ScanHistoryEntity>> call() async {
    return await repository.getScanHistory();
  }
}

class DeleteScanRecordUsecase {
  final ScanHistoryRepository repository;

  DeleteScanRecordUsecase({required this.repository});

  Future<void> call(String scanId) async {
    return await repository.deleteScanRecord(scanId);
  }
}

class ClearScanHistoryUsecase {
  final ScanHistoryRepository repository;

  ClearScanHistoryUsecase({required this.repository});

  Future<void> call() async {
    return await repository.clearScanHistory();
  }
}
