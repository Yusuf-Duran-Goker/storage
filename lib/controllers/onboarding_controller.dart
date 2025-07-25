// lib/controllers/onboarding_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/onboarding_model.dart';
import '../service/onboarding_service.dart';
import '../pages/product_list_page.dart';

class OnboardingController extends GetxController {
  // 1) Mevcut sayfalar
  final pages = <OnboardingPage>[
    OnboardingPage(
      title: 'Hoşgeldiniz',
      description: 'Fake Storage’a hoş geldiniz!',
      lottieAsset: 'assets/anim/welcome.json',
    ),
    OnboardingPage(
      title: 'Yaş & Cinsiyet',
      description: 'Lütfen yaşınızı ve cinsiyetinizi seçin.',
      lottieAsset: 'assets/anim/profile.json', // (sonradan ekleyeceğin asset)
    ),
    OnboardingPage(
      title: 'Sepetiniz',
      description: 'Ürünleri kolayca sepetinize ekleyin.',
      lottieAsset: 'assets/anim/cart.json',
    ),
    OnboardingPage(
      title: 'Favoriler',
      description: 'En beğendiğiniz ürünlere hızlıca ulaşın.',
      lottieAsset: 'assets/anim/star.json',
    ),
    OnboardingPage(
      title: 'Keşfet & Filtrele',
      description: 'Binlerce ürünü kategori ve arama ile kolayca bulun.',
      lottieAsset: 'assets/anim/search.json',
    ),
    OnboardingPage(
      title: 'Güvenli Ödeme',
      description: 'Tüm kart bilgileriniz 256‑bit şifreleme ile korunur.',
      lottieAsset: 'assets/anim/payment.json',
    ),
    OnboardingPage(
      title: 'Kampanyalar',
      description: 'Size özel indirim ve fırsat bildirimlerini kaçırmayın.',
      lottieAsset: 'assets/anim/notification.json',
    ),
  ];

  // 2) PageView kontrolü
  final pageIndex      = 0.obs;
  final pageController = PageController();

  // 3) Kullanıcının seçimlerini tutacak reaktif listeler:
  /// Yaş seçimi için bir int
  final selectedAge    = 18.obs;
  /// Cinsiyet seçimi için bir enum ya da string
  final selectedGender = ''.obs;
  /// İlgi alanı kategorileri
  final selectedCategories = <String>[].obs;

  // 4) OnboardingService (seen + interests kaydetmek için)
  final _service = OnboardingService();

  bool get isLast => pageIndex.value == pages.length - 1;

  void onPageChanged(int idx) => pageIndex.value = idx;

  void next() {
    if (!isLast) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      finish();
    }
  }

  void skip() {
    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> finish() async {
    // 1) Seen flag’ini işaretle
    await _service.markOnboardingSeen();
    // 2) Seçimleri Firestore’a kaydet
    await _service.saveOnboardingData(
      age: selectedAge.value,
      gender: selectedGender.value,
      interests: selectedCategories.toList(),
    );
    // 3) Ana sayfaya geç
    Get.offAll(() => const ProductListPage());
  }
}
