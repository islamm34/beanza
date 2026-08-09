class AuthenticationEntity {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? profileImage;
  final String accessToken;
  final String refreshToken;

  AuthenticationEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.profileImage,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          fullName == other.fullName &&
          phoneNumber == other.phoneNumber &&
          profileImage == other.profileImage &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      fullName.hashCode ^
      phoneNumber.hashCode ^
      profileImage.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode;
}
