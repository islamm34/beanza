class CafeEntity {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> tags;
  final double distance;

  CafeEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.tags,
    required this.distance,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CafeEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          rating == other.rating &&
          reviewCount == other.reviewCount &&
          imageUrl == other.imageUrl &&
          tags == other.tags &&
          distance == other.distance;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      rating.hashCode ^
      reviewCount.hashCode ^
      imageUrl.hashCode ^
      tags.hashCode ^
      distance.hashCode;
}

class CafeReviewEntity {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final String createdAt;

  CafeReviewEntity({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CafeReviewEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userName == other.userName &&
          userImage == other.userImage &&
          rating == other.rating &&
          comment == other.comment &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userName.hashCode ^
      userImage.hashCode ^
      rating.hashCode ^
      comment.hashCode ^
      createdAt.hashCode;
}
