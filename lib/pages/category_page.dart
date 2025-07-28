// lib/pages/category_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'category_products_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProductController>();

    return Obx(() {
      final cats = pc.categories
          .where((c) => c.toLowerCase() != 'all')
             .toList();
      if (cats.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final categoryImages = <String, String>{
        'electronics'       : '',
        'jewelery'          : 'https://www.europastarjewellery.com/local/cache-vignettes/L1000xH429/00de4e2bbc4d27e67483eb8f19a6d5-653a1.jpg?1752610768',
        'men\'s clothing'   : '',
        'women\'s clothing' : '',
      };

      return ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 16, 16, kBottomNavigationBarHeight + 16),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final cat = cats[i];
          final productsOfCat = pc.products.where((p) => p.category == cat).toList();
          final fixedUrl = categoryImages[cat] ?? '';

          // ——— Görsel widget’ı ———
          Widget imageWidget;
          if (fixedUrl.startsWith('http')) {
            imageWidget = Image.network(
              fixedUrl, width: 100, height: 100, fit: BoxFit.cover,
              loadingBuilder: (c, child, prog) {
                if (prog == null) return child;
                return SizedBox(
                  width: 100, height: 100,
                  child: Center(child: CircularProgressIndicator(
                    value: prog.expectedTotalBytes != null
                        ? prog.cumulativeBytesLoaded / prog.expectedTotalBytes!
                        : null,
                  )),
                );
              },
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 100, height: 100,
                child: Center(child: Icon(Icons.broken_image)),
              ),
            );
          } else if (productsOfCat.isNotEmpty) {
            imageWidget = Image.network(
              productsOfCat.first.image,
              width: 100, height: 100, fit: BoxFit.cover,
              loadingBuilder: (c, child, prog) {
                if (prog == null) return child;
                return const SizedBox(
                  width: 100, height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 100, height: 100,
                child: Center(child: Icon(Icons.broken_image)),
              ),
            );
          } else {
            imageWidget = const SizedBox(
              width: 100, height: 100,
              child: Center(child: Icon(Icons.category)),
            );
          }

          final count = productsOfCat.length;

          // ——— Burada GestureDetector kullanıyoruz ———
          return GestureDetector(
            onTap: () {
              // Tıklanınca yeni sayfaya geçiş
              Get.to(() => CategoryProductsPage(category: cat));
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: imageWidget,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat[0].toUpperCase() + cat.substring(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$count Products',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
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
