class UserProfileEntity {
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

  UserProfileEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          fullName == other.fullName &&
          phoneNumber == other.phoneNumber &&
          profileImage == other.profileImage &&
          dateOfBirth == other.dateOfBirth &&
          address == other.address &&
          memberSince == other.memberSince &&
          emailVerified == other.emailVerified &&
          phoneVerified == other.phoneVerified;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      fullName.hashCode ^
      phoneNumber.hashCode ^
      profileImage.hashCode ^
      dateOfBirth.hashCode ^
      address.hashCode ^
      memberSince.hashCode ^
      emailVerified.hashCode ^
      phoneVerified.hashCode;
}
