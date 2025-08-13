import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'category_products_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProductController>();

    return Obx(() {
      // 1) boş 'All' dışındaki kategoriler zaten boş string içermiyor
      final cats = pc.categories.where((c) => c.toLowerCase() != 'all').toList();
      if (cats.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, kBottomNavigationBarHeight + 16),
        itemCount: cats.length,
        itemBuilder: (context, i) {
          final cat = cats[i];
          final lower = cat.toLowerCase();

          // 2) case-insensitive filtre
          final catProducts = pc.products
              .where((p) => p.category.toLowerCase() == lower)
              .toList();
          if (catProducts.isEmpty) return const SizedBox.shrink();

          final count = catProducts.length;
          final imageUrl = catProducts.first.image;

          final isEven = i.isEven;

          Widget imageWidget = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              loadingBuilder: (c, child, prog) =>
              prog == null ? child : const Center(child: CircularProgressIndicator()),
              errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.broken_image)),
            ),
          );

          Widget textWidget = Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('$count Products', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          );

          return Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.zero,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Get.to(() => CategoryProductsPage(category: cat)),
                  child: SizedBox(
                    height: 120,
                    child: Row(
                      children: isEven
                          ? [textWidget, imageWidget]
                          : [imageWidget, textWidget],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      );
    });
  }
}
