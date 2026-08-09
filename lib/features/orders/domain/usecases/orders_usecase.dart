import '../entities/orders_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUsecase {
  final OrdersRepository repository;

  GetOrdersUsecase({required this.repository});

  Future<List<OrderEntity>> call({String? status}) async {
    return await repository.getOrders(status: status);
  }
}

class GetOrderDetailsUsecase {
  final OrdersRepository repository;

  GetOrderDetailsUsecase({required this.repository});

  Future<OrderEntity> call(String orderId) async {
    return await repository.getOrderDetails(orderId);
  }
}

class CancelOrderUsecase {
  final OrdersRepository repository;

  CancelOrderUsecase({required this.repository});

  Future<void> call(String orderId) async {
    return await repository.cancelOrder(orderId);
  }
}

class ReorderUsecase {
  final OrdersRepository repository;

  ReorderUsecase({required this.repository});

  Future<OrderEntity> call(String orderId) async {
    return await repository.reorder(orderId);
  }
}
