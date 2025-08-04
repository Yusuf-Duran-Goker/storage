import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoUploaderController extends GetxController {
  final _picker = ImagePicker();
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  final RxList<String> videoUrls = <String>[].obs;
  final RxBool isUploading = false.obs;
  final RxBool isLoading = false.obs;

  String get _uid => _auth.currentUser!.uid;

  /// Video seçip yükleme
  Future<void> pickAndUploadVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;

    isUploading.value = true;

    final file = File(pickedFile.path);
    final uploadResult = await _uploadVideo(file);
    if (uploadResult != null) {
      await _saveVideoUrl(uploadResult);
      videoUrls.insert(0, uploadResult); // En son eklenen başta
    }

    isUploading.value = false;
  }

  /// Storage’a yükleme
  Future<String?> _uploadVideo(File file) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('users/$_uid/videos/$fileName.mp4');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Yükleme Hatası', e.toString());
      return null;
    }
  }

  /// Firestore’a URL kaydı
  Future<void> _saveVideoUrl(String url) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('videos')
        .add({
      'url': url,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Videoları Firestore’dan yükleme
  Future<void> loadVideos() async {
    isLoading.value = true;
    try {
      final snaps = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('videos')
          .orderBy('createdAt', descending: true)
          .get();

      videoUrls.assignAll(snaps.docs.map((doc) => doc['url'] as String));
    } catch (e) {
      Get.snackbar('Yükleme Hatası', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Video silme: Firestore + Storage
  Future<void> deleteVideo(int index) async {
    final url = videoUrls[index];

    try {
      // Firestore'dan sil
      final snap = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('videos')
          .where('url', isEqualTo: url)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        await snap.docs.first.reference.delete();
      }

      // Storage’dan sil
      final ref = _storage.refFromURL(url);
      await ref.delete();

      // Listeden çıkar
      videoUrls.removeAt(index);

      Get.snackbar('Başarılı', 'Video kaldırıldı');
    } catch (e) {
      Get.snackbar('Silme Hatası', e.toString());
    }
  }
}
