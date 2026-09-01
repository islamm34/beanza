class ProductVariantEntity {
  final String id;
  final String name;
  final double price;
  final String size;
  final List<String> customizations;

  ProductVariantEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.customizations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          size == other.size &&
          customizations == other.customizations;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      size.hashCode ^
      customizations.hashCode;
}

class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<ProductVariantEntity> variants;
  final String category;
  final bool isAvailable;

  double get price => basePrice;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    double? basePrice,
    double? price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.variants,
    required this.category,
    required this.isAvailable,
  }) : basePrice = basePrice ?? price ?? 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          basePrice == other.basePrice &&
          imageUrl == other.imageUrl &&
          rating == other.rating &&
          reviewCount == other.reviewCount &&
          variants == other.variants &&
          category == other.category &&
          isAvailable == other.isAvailable;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      basePrice.hashCode ^
      imageUrl.hashCode ^
      rating.hashCode ^
      reviewCount.hashCode ^
      variants.hashCode ^
      category.hashCode ^
      isAvailable.hashCode;
}

class ProductReviewEntity {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;

  ProductReviewEntity({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductReviewEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userName == other.userName &&
          rating == other.rating &&
          comment == other.comment &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userName.hashCode ^
      rating.hashCode ^
      comment.hashCode ^
      createdAt.hashCode;
}
