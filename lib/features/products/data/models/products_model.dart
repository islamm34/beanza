class ProductVariantModel {
  final String id;
  final String name;
  final double price;
  final String size;
  final List<String> customizations;

  ProductVariantModel({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.customizations,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      size: json['size'] as String? ?? '',
      customizations: List<String>.from(json['customizations'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'size': size,
    'customizations': customizations,
  };
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<ProductVariantModel> variants;
  final String category;
  final bool isAvailable;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.variants,
    required this.category,
    required this.isAvailable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((v) => ProductVariantModel.fromJson(v as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'basePrice': basePrice,
    'imageUrl': imageUrl,
    'rating': rating,
    'reviewCount': reviewCount,
    'variants': variants.map((v) => v.toJson()).toList(),
    'category': category,
    'isAvailable': isAvailable,
  };
}

class ProductReviewModel {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;

  ProductReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt,
  };
}
