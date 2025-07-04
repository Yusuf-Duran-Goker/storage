// lib/controllers/favorite_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class FavoriteController extends GetxController {
  final _auth  = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  /// Favori ürün ID’lerini tutan reaktif liste
  RxList<int> favorites = <int>[].obs;

  String get _uid => _auth.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    // Oturum açıldığında Firestore’dan veriyi yükle
    _auth.authStateChanges().listen((user) {
      if (user != null) _loadFavorites();
      else favorites.clear();
    });
  }

  /// Firestore’dan mevcut favorileri okur
  Future<void> _loadFavorites() async {
    final doc = await _store.collection('users').doc(_uid).get();
    final data = doc.data();
    final List<dynamic>? list = data?['favorites'];
    if (list != null) {
      favorites.assignAll(list.cast<int>());
    } else {
      favorites.clear();
    }
  }

  /// Toggle et ve Firestore’a kaydet
  Future<void> toggleFavorite(Product p) async {
    final id = p.id;
    if (favorites.contains(id)) favorites.remove(id);
    else favorites.add(id);

    await _store.collection('users').doc(_uid).set({
      'favorites': favorites.toList(),
    }, SetOptions(merge: true));
  }

  bool isFavorite(Product p) => favorites.contains(p.id);
}
