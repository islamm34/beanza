class MenuCategoryEntity {
  final String id;
  final String name;
  final String icon;
  final int itemCount;

  MenuCategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.itemCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuCategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon &&
          itemCount == other.itemCount;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ icon.hashCode ^ itemCount.hashCode;
}

class MenuItemEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool isAvailable;
  final List<String> addons;

  MenuItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.isAvailable,
    required this.addons,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          price == other.price &&
          imageUrl == other.imageUrl &&
          categoryId == other.categoryId &&
          isAvailable == other.isAvailable &&
          addons == other.addons;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      imageUrl.hashCode ^
      categoryId.hashCode ^
      isAvailable.hashCode ^
      addons.hashCode;
}
