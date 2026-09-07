import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/cart_item_model.dart';
import '../../core/models/product_model.dart';
import '../../core/models/table_session_model.dart';
import 'cart_controller.dart';

class TableSessionController extends GetxController {
  final currentSession = Rxn<TableSession>();
  final currentParticipant = Rxn<TableParticipant>();
  final orderItems = <CartItem>[].obs;
  final isSubmittingOrder = false.obs;

  bool get hasActiveSession => currentSession.value != null;
  String get tableNumber => currentSession.value?.tableNumber ?? 'N/A';
  int get participantCount => currentSession.value?.participants.length ?? 0;
  bool get isSubmitted => currentSession.value?.isSubmitted ?? false;

  double get subtotal =>
      orderItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.08;

  double get serviceFee => orderItems.isEmpty ? 0.0 : 2.50;

  double get total => subtotal + tax + serviceFee;

  int get totalItemCount =>
      orderItems.fold<int>(0, (sum, item) => sum + item.quantity);

  int get readyParticipantCount {
    if (currentSession.value == null) return 0;
    return currentSession.value!.participants.where((p) => p.isDone).length;
  }

  bool get allParticipantsDone {
    if (currentSession.value == null ||
        currentSession.value!.participants.isEmpty) {
      return false;
    }
    final participants = currentSession.value!.participants;
    for (var p in participants) {
      final pItems = participantItems(p.participantId);
      if (pItems.isEmpty || !p.isDone) {
        return false;
      }
    }
    return true;
  }

  String get readinessMessage {
    if (currentSession.value == null) return '';
    if (isSubmitted) {
      return 'Order Sent to Barista (تم إرسال الطلب للباريستا)';
    }
    if (allParticipantsDone) {
      return 'Everyone is ready (جميع الضيوف جاهزون)';
    }
    final total = participantCount;
    final ready = readyParticipantCount;
    final remaining = total - ready;
    return '$ready of $total guests are ready (في انتظار $remaining ضيف)';
  }

  double participantSubtotal(String participantId) {
    return orderItems
        .where((item) => item.participantId == participantId)
        .fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  List<CartItem> participantItems(String participantId) {
    return orderItems
        .where((item) => item.participantId == participantId)
        .toList();
  }

  void markParticipantDone(String participantId) {
    final session = currentSession.value;
    if (session == null) return;
    final p = session.participants
        .firstWhereOrNull((item) => item.participantId == participantId);
    if (p != null) {
      final items = participantItems(participantId);
      if (items.isNotEmpty) {
        p.status = 'done';
        _updateSessionStatus();
        currentSession.refresh();
      }
    }
  }

  void markParticipantEditing(String participantId) {
    final session = currentSession.value;
    if (session == null || isSubmitted) return;
    final p = session.participants
        .firstWhereOrNull((item) => item.participantId == participantId);
    if (p != null) {
      p.status = 'editing';
      _updateSessionStatus();
      currentSession.refresh();
    }
  }

  void toggleParticipantDoneStatus(String participantId) {
    final session = currentSession.value;
    if (session == null || isSubmitted) return;
    final p = session.participants
        .firstWhereOrNull((item) => item.participantId == participantId);
    if (p != null) {
      if (p.isDone) {
        markParticipantEditing(participantId);
      } else {
        markParticipantDone(participantId);
      }
    }
  }

  void _updateSessionStatus() {
    final session = currentSession.value;
    if (session == null || isSubmitted) return;
    if (allParticipantsDone) {
      session.status = 'ready';
    } else {
      session.status = 'collecting';
    }
  }

  void _onCurrentUserModifiedOrder() {
    final me = currentParticipant.value;
    if (me != null && me.isDone && !isSubmitted) {
      me.status = 'editing';
      _updateSessionStatus();
    }
  }

  void startSingleMemberSession({
    required String tableId,
    required String tableNumber,
    required String participantName,
  }) {
    final now = DateTime.now();
    final pId = 'p_${now.millisecondsSinceEpoch}';

    final me = TableParticipant(
      participantId: pId,
      displayName: participantName,
      joinedAt: now,
      isCurrentUser: true,
      isHost: true,
      avatarColor: const Color(0xFF6F4E37),
      status: 'editing',
    );

    orderItems.clear();

    final session = TableSession(
      sessionId: 'sess_${now.millisecondsSinceEpoch}',
      tableId: tableId,
      tableNumber: tableNumber,
      status: 'collecting',
      participants: [me],
      orderItems: orderItems,
      createdAt: now,
    );

    currentParticipant.value = me;
    currentSession.value = session;

    _syncWithCartController();
  }

  void joinTableSession({
    required String tableId,
    required String tableNumber,
    required String participantName,
  }) {
    final now = DateTime.now();
    final pId = 'p_${now.millisecondsSinceEpoch}';

    final me = TableParticipant(
      participantId: pId,
      displayName: participantName,
      joinedAt: now,
      isCurrentUser: true,
      isHost: true,
      avatarColor: const Color(0xFF6F4E37),
      status: 'editing',
    );

    orderItems.clear();

    // TODO: Replace local empty-table state with backend session members
    // when the real table-session backend is connected.
    final session = TableSession(
      sessionId: 'sess_${now.millisecondsSinceEpoch}',
      tableId: tableId,
      tableNumber: tableNumber,
      status: 'collecting',
      participants: [me],
      orderItems: orderItems,
      createdAt: now,
    );

    currentParticipant.value = me;
    currentSession.value = session;

    _syncWithCartController();
  }

  void addItemToTableOrder({
    required Product product,
    required ProductSize size,
    required MilkOption milk,
    List<Extra> extras = const [],
    int quantity = 1,
  }) {
    if (currentSession.value == null ||
        currentParticipant.value == null ||
        isSubmitted) return;

    final me = currentParticipant.value!;
    _onCurrentUserModifiedOrder();

    final existingIndex = orderItems.indexWhere(
      (item) =>
          item.participantId == me.participantId &&
          item.product.id == product.id &&
          item.selectedSize.name == size.name &&
          item.selectedMilk.name == milk.name &&
          _areExtrasEqual(item.selectedExtras, extras),
    );

    if (existingIndex >= 0) {
      orderItems[existingIndex].quantity += quantity;
      orderItems.refresh();
    } else {
      final newItem = CartItem(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        selectedSize: size,
        selectedMilk: milk,
        selectedExtras: List.from(extras),
        quantity: quantity,
        participantId: me.participantId,
        participantName: me.displayName,
      );
      orderItems.add(newItem);
    }

    currentSession.refresh();
    _syncWithCartController();
  }

  void incrementItemQuantity(String id) {
    if (isSubmitted) return;
    final index = orderItems.indexWhere((i) => i.id == id);
    if (index >= 0) {
      if (orderItems[index].participantId ==
          currentParticipant.value?.participantId) {
        _onCurrentUserModifiedOrder();
        orderItems[index].quantity++;
        orderItems.refresh();
        currentSession.refresh();
        _syncWithCartController();
      }
    }
  }

  void decrementItemQuantity(String id) {
    if (isSubmitted) return;
    final index = orderItems.indexWhere((i) => i.id == id);
    if (index >= 0) {
      if (orderItems[index].participantId ==
          currentParticipant.value?.participantId) {
        _onCurrentUserModifiedOrder();
        if (orderItems[index].quantity > 1) {
          orderItems[index].quantity--;
          orderItems.refresh();
        } else {
          orderItems.removeAt(index);
        }
        currentSession.refresh();
        _syncWithCartController();
      }
    }
  }

  void removeItem(String id) {
    if (isSubmitted) return;
    _onCurrentUserModifiedOrder();
    orderItems.removeWhere((i) =>
        i.id == id &&
        i.participantId == currentParticipant.value?.participantId);
    currentSession.refresh();
    _syncWithCartController();
  }

  void clearCurrentUserItems() {
    if (isSubmitted) return;
    _onCurrentUserModifiedOrder();
    final meId = currentParticipant.value?.participantId;
    orderItems.removeWhere((i) => i.participantId == meId);
    currentSession.refresh();
    _syncWithCartController();
  }

  Future<bool> submitTableOrder() async {
    if (currentSession.value == null ||
        orderItems.isEmpty ||
        !allParticipantsDone ||
        isSubmitted) {
      return false;
    }

    isSubmittingOrder.value = true;
    currentSession.value!.status = 'submitting';

    await Future.delayed(const Duration(milliseconds: 1200));

    currentSession.value!.status = 'submitted';
    isSubmittingOrder.value = false;

    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().clearCart();
    }

    currentSession.refresh();
    return true;
  }

  void leaveTableSession() {
    orderItems.clear();
    currentSession.value = null;
    currentParticipant.value = null;
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().clearCart();
    }
  }

  void _syncWithCartController() {
    if (Get.isRegistered<CartController>()) {
      final cartCtrl = Get.find<CartController>();
      cartCtrl.cartItems.assignAll(orderItems);
    }
  }

  bool _areExtrasEqual(List<Extra> list1, List<Extra> list2) {
    if (list1.length != list2.length) return false;
    final names1 = list1.map((e) => e.name).toList()..sort();
    final names2 = list2.map((e) => e.name).toList()..sort();
    for (int i = 0; i < names1.length; i++) {
      if (names1[i] != names2[i]) return false;
    }
    return true;
  }
}
