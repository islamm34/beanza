import '../../domain/entities/checkout_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_data_source.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AddressEntity>> getSavedAddresses() async {
    try {
      final addresses = await remoteDataSource.getSavedAddresses();
      return addresses
          .map(
            (addr) => AddressEntity(
              id: addr['id'] as String? ?? '',
              label: addr['label'] as String? ?? '',
              street: addr['street'] as String? ?? '',
              city: addr['city'] as String? ?? '',
              state: addr['state'] as String? ?? '',
              zipCode: addr['zipCode'] as String? ?? '',
              latitude: (addr['latitude'] as num?)?.toDouble() ?? 0.0,
              longitude: (addr['longitude'] as num?)?.toDouble() ?? 0.0,
              isDefault: addr['isDefault'] as bool? ?? false,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get saved addresses: $e');
    }
  }

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    try {
      final methods = await remoteDataSource.getPaymentMethods();
      return methods
          .map(
            (method) => PaymentMethodEntity(
              id: method['id'] as String? ?? '',
              type: method['type'] as String? ?? 'card',
              lastDigits: method['lastDigits'] as String? ?? '',
              cardholderName: method['cardholderName'] as String? ?? '',
              expiryDate: method['expiryDate'] as String? ?? '',
              isDefault: method['isDefault'] as bool? ?? false,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get payment methods: $e');
    }
  }

  @override
  Future<OrderEntity> createOrder(Map<String, dynamic> orderData) async {
    try {
      final result = await remoteDataSource.createOrder(orderData);
      return OrderEntity(
        id: result['id'] as String? ?? '',
        status: result['status'] as String? ?? 'pending',
        total: (result['total'] as num?)?.toDouble() ?? 0.0,
        deliveryAddress: result['deliveryAddress'] as String? ?? '',
        paymentMethod: result['paymentMethod'] as String? ?? '',
        createdAt: result['createdAt'] as String? ?? '',
        items: [],
        cafeImage: '',
        cafeName: '',
      );
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> applyCoupon(String couponCode) async {
    try {
      return await remoteDataSource.applyCoupon(couponCode);
    } catch (e) {
      throw Exception('Failed to apply coupon: $e');
    }
  }
}
