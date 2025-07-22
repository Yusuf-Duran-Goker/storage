// lib/pages/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/onboarding_controller.dart';
import '../controllers/product_controller.dart';
import '../models/onboarding_model.dart';
import '../utils/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: ctrl.pageController,
                itemCount: ctrl.pages.length,
                onPageChanged: ctrl.onPageChanged,
                itemBuilder: (ctx, i) {
                  if (i == 0) return _infoPage(ctrl.pages[i]);
                  if (i == 1) return _ageGenderPage(ctrl);
                  if (i == 2) return _infoPage(ctrl.pages[i]);
                  if (i == 3) return _infoPage(ctrl.pages[i]);
                  if (i == 4) return _categoriesPage(ctrl);
                  // 5 ve sonrası yine bilgi sayfaları
                  return _infoPage(ctrl.pages[i]);
                },
              ),
            ),

            Obx(() {
              // sayfa göstergeleri
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  ctrl.pages.length,
                      (idx) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: ctrl.pageIndex.value == idx ? 12 : 8,
                    height: ctrl.pageIndex.value == idx ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ctrl.pageIndex.value == idx
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() {
                final isLast = ctrl.isLast;
                return ElevatedButton(
                  onPressed: ctrl.next,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(isLast ? 'Başla' : 'İleri'),
                );
              }),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── Helper methods ───────────────────────────────────

  /// Genel bilgi sayfaları (lottie + başlık + açıklama)
  Widget _infoPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(page.lottieAsset, height: 300, fit: BoxFit.contain),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(page.description, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Yaş & Cinsiyet seçimi sayfası
  Widget _ageGenderPage(OnboardingController ctrl) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Yaşınızı Seçin', style: TextStyle(fontSize: 20)),
          Obx(() => Slider(
            value: ctrl.selectedAge.value.toDouble(),
            min: 10,
            max: 100,
            divisions: 90,
            label: '${ctrl.selectedAge.value}',
            onChanged: (v) => ctrl.selectedAge.value = v.toInt(),
          )),
          const SizedBox(height: 16),
          const Text('Cinsiyet', style: TextStyle(fontSize: 20)),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Erkek', 'Kadın', 'Diğer'].map((g) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(g),
                    selected: ctrl.selectedGender.value == g,
                    onSelected: (_) => ctrl.selectedGender.value = g,
                    selectedColor: AppColors.primary,
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  /// Kategori seçimi sayfası
  Widget _categoriesPage(OnboardingController ctrl) {
    final prodC = Get.find<ProductController>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('İlgi Alanlarınızı Seçin', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final chips = prodC.categories
                  .map<Widget>((cat) {
                final sel = ctrl.selectedCategories.contains(cat);
                return ChoiceChip(
                  key: ValueKey(cat),
                  label: Text(cat),
                  selected: sel,
                  onSelected: (v) {
                    if (v) {
                      ctrl.selectedCategories.add(cat);
                    } else {
                      ctrl.selectedCategories.remove(cat);
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: sel ? Colors.white : Colors.black87,
                  ),
                );
              })
                  .toList(); // RxList<String> → List<Widget>

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
