import 'package:get/get.dart';
import '../../features/notifications/domain/entities/notification.dart';
import 'notifications_controller.dart';

class RewardItem {
  final String id;
  final String title;
  final int pointsRequired;
  final String description;
  final String image;

  RewardItem({
    required this.id,
    required this.title,
    required this.pointsRequired,
    required this.description,
    required this.image,
  });
}

class RewardsController extends GetxController {
  final points = 350.obs;
  final availableRewards = <RewardItem>[
    RewardItem(
      id: 'rew_1',
      title: 'Free Espresso',
      pointsRequired: 150,
      description: 'Redeem for any single or double espresso shot.',
      image: 'assets/images/rewards/espresso.jpg',
    ),
    RewardItem(
      id: 'rew_2',
      title: 'Free Pastry or Muffin',
      pointsRequired: 200,
      description: 'Enjoy a fresh baked pastry of your choice.',
      image: 'assets/images/rewards/pastry.jpg',
    ),
    RewardItem(
      id: 'rew_3',
      title: 'Free Specialty Beverage',
      pointsRequired: 300,
      description: 'Redeem for any Large Specialty coffee drink.',
      image: 'assets/images/rewards/specialty.jpg',
    ),
  ].obs;

  bool redeemReward(RewardItem item) {
    if (points.value >= item.pointsRequired) {
      points.value -= item.pointsRequired;
      Get.snackbar(
        'Reward Redeemed',
        'You successfully redeemed ${item.title}!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Trigger local reward notification
      if (Get.isRegistered<NotificationsController>()) {
        Get.find<NotificationsController>().triggerNotification(
          title: 'Reward Available 🎁',
          body: 'You successfully redeemed ${item.title}!',
          payload: '/rewards',
          type: NotificationType.reward,
        );
      }

      return true;
    } else {
      Get.snackbar(
        'Insufficient Points',
        'You need ${item.pointsRequired - points.value} more points.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
