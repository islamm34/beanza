import '../entities/checkout_entity.dart';
import '../repositories/checkout_repository.dart';

class GetSavedAddressesUsecase {
  final CheckoutRepository repository;

  GetSavedAddressesUsecase({required this.repository});

  Future<List<AddressEntity>> call() async {
    return await repository.getSavedAddresses();
  }
}

class GetPaymentMethodsUsecase {
  final CheckoutRepository repository;

  GetPaymentMethodsUsecase({required this.repository});

  Future<List<PaymentMethodEntity>> call() async {
    return await repository.getPaymentMethods();
  }
}

class CreateOrderUsecase {
  final CheckoutRepository repository;

  CreateOrderUsecase({required this.repository});

  Future<OrderEntity> call(Map<String, dynamic> orderData) async {
    return await repository.createOrder(orderData);
  }
}

class ApplyCouponUsecase {
  final CheckoutRepository repository;

  ApplyCouponUsecase({required this.repository});

  Future<Map<String, dynamic>> call(String couponCode) async {
    return await repository.applyCoupon(couponCode);
  }
}
