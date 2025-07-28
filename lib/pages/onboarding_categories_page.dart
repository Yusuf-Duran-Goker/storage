// lib/pages/onboarding_categories_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';
import '../controllers/product_controller.dart';
import '../utils/app_colors.dart';

class OnboardingCategoriesPage extends StatelessWidget {
  const OnboardingCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onbC = Get.find<OnboardingController>();
    final prodC = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlgi Alanlarınızı Seçin'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // 1) RxList<String> → List<Widget> dönüşümü
              final chips = prodC.categories
                  .map<Widget>((cat) {
                final selected = onbC.selectedCategories.contains(cat);
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (sel) {
                    if (sel) {
                      onbC.selectedCategories.add(cat);
                    } else {
                      onbC.selectedCategories.remove(cat);
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                  ),
                );
              })
                  .toList(); // ← burası çok önemli!

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
          // “İleri” butonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: AppColors.primary,
              ),
              onPressed: onbC.next,
              child: const Text('İleri'),
            ),
          ),
        ],
      ),
    );
  }
}
