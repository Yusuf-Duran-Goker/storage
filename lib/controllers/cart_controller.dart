import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  /// id → adet tutan reaktif map
  final RxMap<int,int> cart = <int,int>{}.obs;
  StreamSubscription<DocumentSnapshot>? _sub;

  String get _uid => _auth.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    // Oturum değişimlerini dinle
    _auth.authStateChanges().listen((user) {
      _sub?.cancel();
      if (user != null) {
        // Kullanıcının dökümanını dinle
        _sub = _db
            .collection('users')
            .doc(_uid)
            .snapshots()
            .listen((snap) {
          final data = snap.data() as Map<String, dynamic>? ?? {};
          final raw = Map<String, dynamic>.from(data['cart'] ?? {});
          // string-key’leri int’e dönüştür
          final restored = <int,int>{};
          raw.forEach((k,v) {
            final id = int.tryParse(k);
            if (id != null) restored[id] = (v as num).toInt();
          });
          cart.assignAll(restored);
        });
      } else {
        cart.clear();
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  /// Sepete ekle: id’ye +1, yoksa 1
  Future<void> addToCart(int id) async {
    cart.update(id, (q) => q + 1, ifAbsent: () => 1);
    await _save();
  }

  /// Sepetten çıkar: id’nin adedini -1, 0 ise tamamen sil
  Future<void> removeFromCart(int id) async {
    if (!cart.containsKey(id)) return;
    final q = cart[id]!;
    if (q > 1) {
      cart[id] = q - 1;
    } else {
      cart.remove(id);
    }
    await _save();
  }

  /// Sepette var mı?
  bool contains(int id) => cart.containsKey(id);

  /// Firestore’a kaydet
  Future<void> _save() async {
    final map = { for (var e in cart.entries) e.key.toString(): e.value };
    await _db
        .collection('users')
        .doc(_uid)
        .set({'cart': map}, SetOptions(merge: true));
  }
}
