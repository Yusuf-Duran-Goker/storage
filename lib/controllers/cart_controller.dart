// lib/controllers/cart_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';      // ← Bunu ekleyin
import 'package:get/get.dart'; // firstWhereOrNull için
import 'package:storage/models/product_model.dart';

import 'product_controller.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _authC = Get.find<AuthController>();

  /// Sepet: Product → miktar
  final items = <Product,int>{}.obs;

  late final ProductController _pc;

  @override
  void onInit() {
    super.onInit();
    _pc = Get.find<ProductController>();

    // Uygulama başlarken zaten login ise
    if (_authC.user.value != null) {
      _loadCartFromFirestore();
    }

    // Login/logout durum değişiminde yükle veya temizle
    ever<User?>(_authC.user, (user) {
      if (user != null) {
        _loadCartFromFirestore();
      } else {
        items.clear();
      }
    });
  }

  /// Sepete ekle ve Firestore’a kaydet
  Future<void> addToCart(Product p) async {
    items[p] = (items[p] ?? 0) + 1;
    await _saveCartToFirestore();
  }

  /// Sepetten çıkar ve Firestore’a kaydet
  Future<void> removeFromCart(Product p) async {
    if (!items.containsKey(p)) return;
    final newQty = items[p]! - 1;
    if (newQty > 0) {
      items[p] = newQty;
    } else {
      items.remove(p);
    }
    await _saveCartToFirestore();
  }

  Future<void> _saveCartToFirestore() async {
    final uid = _authC.user.value!.uid;
    final cartMap = <String,int>{};
    items.forEach((prod, qty) {
      cartMap[prod.id.toString()] = qty;
    });
    await _db
        .collection('users')
        .doc(uid)
        .set({'cart': cartMap}, SetOptions(merge: true));
  }

  Future<void> _loadCartFromFirestore() async {
    final uid = _authC.user.value!.uid;
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data();
    if (data == null || data['cart'] == null) return;
    final raw = Map<String, dynamic>.from(data['cart']);

    final restored = <Product,int>{};
    raw.forEach((prodId, qty) {
      final p = _pc.products.firstWhereOrNull((x) => x.id.toString() == prodId);
      if (p != null) restored[p] = qty as int;
    });

    items.assignAll(restored);
  }

  double get totalPrice => items.entries
      .fold(0.0, (sum, e) => sum + e.key.price * e.value);
}
