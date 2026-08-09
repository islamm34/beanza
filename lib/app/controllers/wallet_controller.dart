import 'package:get/get.dart';

class WalletTransaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isTopUp;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.isTopUp = false,
  });
}

class WalletController extends GetxController {
  final balance = 45.50.obs;
  final transactions = <WalletTransaction>[
    WalletTransaction(
      id: 'tx_1',
      title: 'Coffee Order #ORD-8472',
      amount: -12.50,
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    WalletTransaction(
      id: 'tx_2',
      title: 'Wallet Top Up',
      amount: 50.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isTopUp: true,
    ),
  ].obs;

  void topUp(double amount) {
    balance.value += amount;
    transactions.insert(
      0,
      WalletTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Wallet Top Up',
        amount: amount,
        date: DateTime.now(),
        isTopUp: true,
      ),
    );
  }
}
