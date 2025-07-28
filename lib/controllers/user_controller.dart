// lib/controllers/user_controller.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';        // ← SnackBar & Colors için
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Current Firebase user
  Rxn<User> firebaseUser = Rxn<User>();
  /// Profile data from Firestore: firstName, email, age, gender, photoUrl
  Rxn<Map<String, dynamic>> profile = Rxn<Map<String, dynamic>>();
  /// Fotoğraf yükleme durumunu tutar
  RxBool isUploadingPhoto = false.obs;

  /// UI’da kullanmak üzere kolaylaştırılmış getter’lar
  String get displayName => profile.value?['firstName'] as String? ?? 'Guest';
  String? get photoUrl    => profile.value?['photoUrl'] as String?;

  @override
  void onInit() {
    super.onInit();
    // Auth durumunu dinle
    firebaseUser.bindStream(_auth.authStateChanges());
    firebaseUser.listen((u) {
      if (u != null) {
        _startProfileListener(u.uid);
      } else {
        profile.value = null;
      }
    });
  }

  void _startProfileListener(String uid) {
    _db.collection('users').doc(uid).snapshots().listen((snap) {
      profile.value = snap.data();
    });
  }

  /// Genel profil güncelleme (firstName, age, gender)
  Future<void> updateProfile({
    String? firstName,
    int? age,
    String? gender,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final data = <String, dynamic>{};
    if (firstName != null) data['firstName'] = firstName;
    if (age       != null) data['age']       = age;
    if (gender    != null) data['gender']    = gender;
    if (data.isEmpty) return;
    await _db.collection('users').doc(uid)
        .set(data, SetOptions(merge: true));
  }

  /// Sadece adı güncellemek istersen
  Future<void> updateFirstName(String name) async {
    await updateProfile(firstName: name);
  }

  /// Galeriden seçim yapıp Storage’a yükler, Firestore’a URL kaydeder
  Future<void> pickAndUploadPhoto() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    isUploadingPhoto.value = true;
    try {
      // 1) Fotoğrafı seç
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        Get.snackbar('İptal', 'Fotoğraf seçimi iptal edildi',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // 2) Storage yolunu oluştur
      final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path     = 'users/$uid/$filename';
      final ref      = _storage.ref().child(path);

      // 3) Yükleme
      final uploadTask = ref.putFile(File(file.path));
      await uploadTask;

      // 4) URL al & Firestore’a kaydet
      final url = await ref.getDownloadURL();
      await _db.collection('users').doc(uid)
          .set({'photoUrl': url}, SetOptions(merge: true));

      Get.snackbar('Başarılı', 'Profil fotoğrafı güncellendi',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', 'Fotoğraf yüklenemedi: $e',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUploadingPhoto.value = false;
    }
  }
}
