// lib/controllers/profile_controller.dart

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileController extends GetxController {
  final _picker = ImagePicker();

  /// Uzak URL (Storage’dan)
  RxnString avatarUrl = RxnString();
  /// Lokal yol (galeriden seçilmiş)
  RxnString imagePath = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadLocal();
    _loadRemote();
  }

  Future<void> _loadLocal() async {
    // ... SharedPreferences’ten imagePath yükle (senin halihazırdaki kodun) ...
  }

  Future<void> _loadRemote() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final url = doc.data()?['avatarUrl'] as String?;
    if (url != null) avatarUrl.value = url;
  }

  /// 1) Galeriden seç -> 2) Storage’a yükle -> 3) URL al -> 4) Firestore’a kaydet -> 5) avatarUrl’a ata
  Future<void> pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 600);
    if (file == null) return;

    // 1) lokal at
    imagePath.value = file.path;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref('users/$uid/avatar.jpg');

    // 2) upload
    await ref.putFile(File(file.path));

    // 3) download URL
    final url = await ref.getDownloadURL();

    // 4) Firestore’a kaydet
    await FirebaseFirestore.instance.collection('users').doc(uid)
        .set({'avatarUrl': url}, SetOptions(merge: true));

    // 5) RX’e ata
    avatarUrl.value = url;
  }
}
