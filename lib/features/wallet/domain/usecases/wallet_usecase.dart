import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWalletBalanceUsecase {
  final WalletRepository repository;

  GetWalletBalanceUsecase({required this.repository});

  Future<WalletEntity> call() async {
    return await repository.getWalletBalance();
  }
}

class GetTransactionsUsecase {
  final WalletRepository repository;

  GetTransactionsUsecase({required this.repository});

  Future<List<TransactionEntity>> call() async {
    return await repository.getTransactions();
  }
}

class AddMoneyUsecase {
  final WalletRepository repository;

  AddMoneyUsecase({required this.repository});

  Future<void> call(double amount, String paymentMethod) async {
    return await repository.addMoney(amount, paymentMethod);
  }
}
