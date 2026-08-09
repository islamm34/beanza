abstract class WalletRemoteDataSource {
  /// Gets wallet balance
  Future<Map<String, dynamic>> getWalletBalance();

  /// Gets wallet transactions
  Future<List<Map<String, dynamic>>> getTransactions();

  /// Adds money to wallet
  Future<Map<String, dynamic>> addMoney(double amount, String paymentMethod);

  /// Sends money
  Future<Map<String, dynamic>> sendMoney(String recipientId, double amount);
}
