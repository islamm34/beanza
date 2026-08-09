import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<WalletEntity> getWalletBalance();
  Future<List<TransactionEntity>> getTransactions();
  Future<void> addMoney(double amount, String paymentMethod);
}
