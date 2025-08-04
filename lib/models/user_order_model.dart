// lib/models/user_order_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user's order with items, total amount, timestamp, and status.
class UserOrder {
  final String id;
  final Map<int, int> items; // productId → quantity
  final double total;
  final DateTime timestamp;
  final String status;

  UserOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.timestamp,
    this.status = 'pending',
  });

  /// Creates a UserOrder from Firestore data.
  factory UserOrder.fromMap(String id, Map<String, dynamic> map) {
    final rawItems = Map<String, dynamic>.from(map['items'] ?? {});
    final items = rawItems.map<int, int>((key, value) {
      return MapEntry(int.parse(key), (value as num).toInt());
    });

    return UserOrder(
      id: id,
      items: items,
      total: (map['total'] as num).toDouble(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: map['status'] as String? ?? 'pending',
    );
  }

  /// Converts UserOrder to a map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((key, value) => MapEntry(key.toString(), value)),
      'total': total,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }
}
