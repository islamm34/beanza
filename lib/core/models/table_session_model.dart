import 'package:flutter/material.dart';
import 'cart_item_model.dart';

class TableParticipant {
  final String participantId;
  final String displayName;
  final DateTime joinedAt;
  final bool isCurrentUser;
  final bool isHost;
  final Color avatarColor;
  String status; // 'editing', 'done'

  TableParticipant({
    required this.participantId,
    required this.displayName,
    required this.joinedAt,
    this.isCurrentUser = false,
    this.isHost = false,
    this.avatarColor = const Color(0xFF6F4E37),
    this.status = 'editing',
  });

  bool get isDone => status == 'done';
}

class TableSession {
  final String sessionId;
  final String tableId;
  final String tableNumber;
  String
      status; // 'collecting', 'ready', 'submitting', 'submitted', 'submissionFailed'
  final List<TableParticipant> participants;
  final List<CartItem> orderItems;
  final DateTime createdAt;

  TableSession({
    required this.sessionId,
    required this.tableId,
    required this.tableNumber,
    this.status = 'collecting',
    required this.participants,
    required this.orderItems,
    required this.createdAt,
  });

  bool get isSubmitted => status == 'submitted';

  double get subtotal =>
      orderItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.08;

  double get serviceFee => orderItems.isEmpty ? 0.0 : 2.50;

  double get total => subtotal + tax + serviceFee;

  double participantSubtotal(String participantId) {
    return orderItems
        .where((item) => item.participantId == participantId)
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  List<CartItem> participantItems(String participantId) {
    return orderItems
        .where((item) => item.participantId == participantId)
        .toList();
  }
}
