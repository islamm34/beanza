class ScanResultModel {
  final String type; // product, promotion, cafe
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final Map<String, dynamic> data;

  ScanResultModel({
    required this.type,
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.data,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      type: json['type'] as String? ?? '',
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      data: Map<String, dynamic>.from(
          json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'data': data,
      };
}
