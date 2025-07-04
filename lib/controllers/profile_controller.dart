import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  RxnString imagePath = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadSavedAvatar();
  }

  /// SharedPreferences'tan daha önce kaydedilen yolu oku
  Future<void> _loadSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('avatarPath');
    if (path != null && File(path).existsSync()) {
      imagePath.value = path;
    }
  }

  /// Galeriden resim seç, kaydet ve SharedPreferences'a yaz
  Future<void> pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (file != null) {
      imagePath.value = file.path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarPath', file.path);
    }
  }
}
