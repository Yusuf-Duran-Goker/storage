// lib/services/order_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:storage/models/user_order_model.dart';


/// Service for creating and streaming user orders in Firestore.
class OrderService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Creates a new order document under 'users/{uid}/orders'.
  Future<void> createOrder(Map<int,int> items, double total) async {
    final uid = _auth.currentUser!.uid;
    final ordersCollection = _db.collection('users').doc(uid).collection('orders');
    final orderRef = ordersCollection.doc();

    final userOrder = UserOrder(
      id: orderRef.id,
      items: items,
      total: total,
      timestamp: DateTime.now(),
      status: 'pending',
    );

    await orderRef.set(userOrder.toMap());
  }

  /// Streams a list of orders for the current user, ordered by timestamp.
  Stream<List<UserOrder>> ordersStream() {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserOrder.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
