import '../entities/checkout_entity.dart';

abstract class CheckoutRepository {
  Future<List<AddressEntity>> getSavedAddresses();
  Future<List<PaymentMethodEntity>> getPaymentMethods();
  Future<OrderEntity> createOrder(Map<String, dynamic> orderData);
  Future<Map<String, dynamic>> applyCoupon(String couponCode);
}
