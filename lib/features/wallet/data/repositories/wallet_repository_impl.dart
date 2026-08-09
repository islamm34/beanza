import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WalletEntity> getWalletBalance() async {
    try {
      final data = await remoteDataSource.getWalletBalance();
      return WalletEntity(
        balance: (data['balance'] as num?)?.toDouble() ?? 0.0,
        totalSpent: (data['totalSpent'] as num?)?.toDouble() ?? 0.0,
        totalEarned: (data['totalEarned'] as num?)?.toDouble() ?? 0.0,
        currency: data['currency'] as String? ?? 'USD',
        isVerified: data['isVerified'] as bool? ?? false,
      );
    } catch (e) {
      throw Exception('Failed to get wallet balance: $e');
    }
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    try {
      final transactions = await remoteDataSource.getTransactions();
      return transactions
          .map((txn) => TransactionEntity(
            id: txn['id'] as String? ?? '',
            type: txn['type'] as String? ?? 'debit',
            amount: (txn['amount'] as num?)?.toDouble() ?? 0.0,
            description: txn['description'] as String? ?? '',
            timestamp: txn['timestamp'] as String? ?? '',
            status: txn['status'] as String? ?? 'completed',
            cafeId: txn['cafeId'] as String?,
            orderId: txn['orderId'] as String?,
          ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  @override
  Future<void> addMoney(double amount, String paymentMethod) async {
    try {
      await remoteDataSource.addMoney(amount, paymentMethod);
    } catch (e) {
      throw Exception('Failed to add money: $e');
    }
  }
}
