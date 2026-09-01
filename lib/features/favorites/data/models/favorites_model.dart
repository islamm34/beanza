class FavoriteCafeModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String address;
  final double distance;

  FavoriteCafeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.distance,
  });

  factory FavoriteCafeModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCafeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'rating': rating,
        'address': address,
        'distance': distance,
      };
}

class FavoriteProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String cafeId;

  FavoriteProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.cafeId,
  });

  factory FavoriteProductModel.fromJson(Map<String, dynamic> json) {
    return FavoriteProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      cafeId: json['cafeId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'cafeId': cafeId,
      };
}
