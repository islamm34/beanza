class CafeModel {
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

  CafeModel({
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

  factory CafeModel.fromJson(Map<String, dynamic> json) {
    return CafeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'rating': rating,
        'reviewCount': reviewCount,
        'imageUrl': imageUrl,
        'tags': tags,
        'distance': distance,
      };
}

class CafeReviewModel {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final String createdAt;

  CafeReviewModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory CafeReviewModel.fromJson(Map<String, dynamic> json) {
    return CafeReviewModel(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userImage: json['userImage'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'userImage': userImage,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt,
      };
}
