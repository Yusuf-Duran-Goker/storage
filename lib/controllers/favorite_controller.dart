import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  /// Sadece id’leri tutan reaktif set
  final RxSet<int> favoriteIds = <int>{}.obs;
  StreamSubscription<DocumentSnapshot>? _sub;

  String get _uid => _auth.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    // Oturum aç-kapat değişimlerini dinle
    _auth.authStateChanges().listen((user) {
      _sub?.cancel();
      if (user != null) {
        // Kullanıcının dökümanını dinle
        _sub = _store
            .collection('users')
            .doc(_uid)
            .snapshots()
            .listen((snap) {
          final data = snap.data() as Map<String, dynamic>? ?? {};
          final list = (data['favorites'] as List<dynamic>?)?.cast<int>() ?? [];
          favoriteIds.assignAll(list);
        });
      } else {
        favoriteIds.clear();
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  /// Toggle favorite: ekle/çıkar ve Firestore’a yaz
  Future<void> toggleFavorite(int id) async {
    final isAdding = !favoriteIds.contains(id);
    if (isAdding) {
      favoriteIds.add(id);
    } else {
      favoriteIds.remove(id);
    }
    await _store
        .collection('users')
        .doc(_uid)
        .set({'favorites': favoriteIds.toList()}, SetOptions(merge: true));
  }

  bool isFavorite(int id) => favoriteIds.contains(id);
}
