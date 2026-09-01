class UserProfileModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? profileImage;
  final String? dateOfBirth;
  final String? address;
  final String memberSince;
  final bool emailVerified;
  final bool phoneVerified;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.profileImage,
    this.dateOfBirth,
    this.address,
    required this.memberSince,
    required this.emailVerified,
    required this.phoneVerified,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
      memberSince: json['memberSince'] as String? ?? '',
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'profileImage': profileImage,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'memberSince': memberSince,
        'emailVerified': emailVerified,
        'phoneVerified': phoneVerified,
      };
}
