// lib/controllers/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    // 1) user Rx'ine bind edelim
    user.bindStream(_auth.authStateChanges());

    // 2) Her oturum açılmasında Firestore dokümanını kontrol et, yoksa oluştur
    _auth.authStateChanges().listen((u) async {
      if (u == null) return;

      final docRef = _db.collection('users').doc(u.uid);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        // İlk defa giriş yapan kullanıcı için temel alanları set et
        await docRef.set({
          'firstName': u.displayName?.split(' ').first  ?? '',
          'lastName' : u.displayName?.split(' ').skip(1).join(' ') ?? '',
          'email'    : u.email                    ?? '',
          'favorites': <int>[],   // boş liste
          'cart'     : <String,int>{}, // boş map
        });
      }
    });
  }

  /// Yeni kullanıcı kaydı
  Future<void> register(String firstName, String lastName, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;

    // Firestore’a kaydet
    await _db.collection('users').doc(uid).set({
      'firstName': firstName,
      'lastName' : lastName,
      'email'    : email,
      'favorites': <int>[],
      'cart'     : <String,int>{},
    });

    // opsiyonel: hemen user Rx’ini güncelle
    user.value = cred.user;
  }

  Future<void> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();
}
