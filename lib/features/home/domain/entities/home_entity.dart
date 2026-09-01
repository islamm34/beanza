export '../../../products/domain/entities/products_entity.dart'
    show ProductEntity;

class HeroBannerEntity {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String actionLabel;

  HeroBannerEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.actionLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroBannerEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          imageUrl == other.imageUrl &&
          actionLabel == other.actionLabel;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      imageUrl.hashCode ^
      actionLabel.hashCode;
}

class CategoryEntity {
  final String id;
  final String name;
  final String icon;
  final String color;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon &&
          color == other.color;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ icon.hashCode ^ color.hashCode;
}
