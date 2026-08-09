class ScanHistoryEntity {
  final String id;
  final String type;
  final String scannedData;
  final String? resultType;
  final String? resultTitle;
  final String timestamp;
  final bool wasSuccessful;

  ScanHistoryEntity({
    required this.id,
    required this.type,
    required this.scannedData,
    this.resultType,
    this.resultTitle,
    required this.timestamp,
    required this.wasSuccessful,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanHistoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          scannedData == other.scannedData &&
          resultType == other.resultType &&
          resultTitle == other.resultTitle &&
          timestamp == other.timestamp &&
          wasSuccessful == other.wasSuccessful;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      scannedData.hashCode ^
      resultType.hashCode ^
      resultTitle.hashCode ^
      timestamp.hashCode ^
      wasSuccessful.hashCode;
}
