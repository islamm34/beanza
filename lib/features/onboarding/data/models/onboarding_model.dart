class OnboardingScreenModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String color;

  OnboardingScreenModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.color,
  });

  factory OnboardingScreenModel.fromJson(Map<String, dynamic> json) {
    return OnboardingScreenModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      color: json['color'] as String? ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'color': color,
      };
}
