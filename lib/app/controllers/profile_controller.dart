import 'package:get/get.dart';
import '../../core/models/user_model.dart';

class ProfileController extends GetxController {
  final user = User(
    id: 'usr_1001',
    name: 'Alex Johnson',
    email: 'alex.johnson@brewora.co',
    phone: '+1 (555) 234-5678',
    profileImage: 'assets/images/avatars/user_avatar.jpg',
    rewardPoints: 350,
    walletBalance: 45.50,
  ).obs;

  void updateUser({String? name, String? email, String? phone}) {
    user.update((u) {
      if (u != null) {
        user.value = User(
          id: u.id,
          name: name ?? u.name,
          email: email ?? u.email,
          phone: phone ?? u.phone,
          profileImage: u.profileImage,
          rewardPoints: u.rewardPoints,
          walletBalance: u.walletBalance,
        );
      }
    });
  }
}
