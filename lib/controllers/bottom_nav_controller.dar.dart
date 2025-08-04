// lib/controllers/bottom_nav_controller.dart

import 'package:get/get.dart';

/// Alt navigasyon çubuğu için GetX kontrolcüsü.
class BottomNavController extends GetxController {
  /// Şu anki sekme indeksi.
  final currentIndex = 0.obs;

  /// Sekme indeksini değiştirir.
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
