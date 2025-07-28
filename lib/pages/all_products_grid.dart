// lib/pages/all_products_grid.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/product_controller.dart';
import 'package:storage/controllers/favorite_controller.dart';
import 'package:storage/pages/product_detail_page.dart';  // detay sayfası importu
import '../utils/app_colors.dart';

class AllProductsGrid extends StatelessWidget {
  const AllProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final pc   = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();

    return Obx(() {
      if (pc.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (pc.error.value.isNotEmpty) {
        return Center(child: Text('Error: ${pc.error.value}'));
      }

      final allProducts = pc.products;
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70,
        ),
        itemCount: allProducts.length,
        itemBuilder: (context, i) {
          final p = allProducts[i];
          return GestureDetector(
            onTap: () => Get.to(() => ProductDetailPage(product: p)),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(p.image, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          p.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Text(
                          '\$${p.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Obx(() => InkWell(
                      onTap: () => favC.toggleFavorite(p.id),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          favC.isFavorite(p.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: favC.isFavorite(p.id)
                              ? Colors.red
                              : Colors.grey.shade600,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
