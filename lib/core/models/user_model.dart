class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  int rewardPoints;
  double walletBalance;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    this.rewardPoints = 250,
    this.walletBalance = 45.00,
  });
}
