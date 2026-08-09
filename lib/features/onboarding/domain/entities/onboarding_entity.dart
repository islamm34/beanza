class OnboardingEntity {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String color;

  OnboardingEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          color == other.color;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      color.hashCode;
}
