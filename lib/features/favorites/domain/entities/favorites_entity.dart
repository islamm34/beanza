class FavoriteCafeEntity {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String address;
  final double distance;

  FavoriteCafeEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.distance,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteCafeEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          imageUrl == other.imageUrl &&
          rating == other.rating &&
          address == other.address &&
          distance == other.distance;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      imageUrl.hashCode ^
      rating.hashCode ^
      address.hashCode ^
      distance.hashCode;
}

class FavoriteProductEntity {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String cafeId;

  FavoriteProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.cafeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          imageUrl == other.imageUrl &&
          cafeId == other.cafeId;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ price.hashCode ^ imageUrl.hashCode ^ cafeId.hashCode;
}
