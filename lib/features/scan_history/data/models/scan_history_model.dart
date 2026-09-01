class ScanHistoryModel {
  final String id;
  final String type; // qr, barcode
  final String scannedData;
  final String? resultType; // product, cafe, promotion
  final String? resultTitle;
  final String timestamp;
  final bool wasSuccessful;

  ScanHistoryModel({
    required this.id,
    required this.type,
    required this.scannedData,
    this.resultType,
    this.resultTitle,
    required this.timestamp,
    required this.wasSuccessful,
  });

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'qr',
      scannedData: json['scannedData'] as String? ?? '',
      resultType: json['resultType'] as String?,
      resultTitle: json['resultTitle'] as String?,
      timestamp: json['timestamp'] as String? ?? '',
      wasSuccessful: json['wasSuccessful'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'scannedData': scannedData,
        'resultType': resultType,
        'resultTitle': resultTitle,
        'timestamp': timestamp,
        'wasSuccessful': wasSuccessful,
      };
}
