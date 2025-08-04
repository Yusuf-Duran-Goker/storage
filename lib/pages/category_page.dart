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
      final cats = pc.categories
          .where((c) => c.toLowerCase() != 'all')
          .toList();
      if (cats.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final categoryImages = <String, String>{
        'electronics': '',
        'jewelery': 'https://www.europastarjewellery.com/local/cache-vignettes/L1000xH429/00de4e2bbc4d27e67483eb8f19a6d5-653a1.jpg?1752610768',
        'men\'s clothing': '',
        'women\'s clothing': '',
      };

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, kBottomNavigationBarHeight + 16),
        itemCount: cats.length,
        itemBuilder: (context, i) {
          final cat = cats[i];
          final count = pc.products.where((p) => p.category == cat).length;
          final fallbackImage = pc.products.firstWhere(
                (p) => p.category == cat,
            orElse: () => pc.products.first,
          ).image;
          final imageUrl = (categoryImages[cat]?.isNotEmpty == true)
              ? categoryImages[cat]!
              : fallbackImage;

          final isEven = i % 2 == 0;

          Widget imageWidget = Image.network(
            imageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            loadingBuilder: (c, child, prog) {
              if (prog == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
          );

          Widget textWidget = Expanded(
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
                          ? [
                        // Text left, image right
                        textWidget,
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          child: imageWidget,
                        ),
                      ]
                          : [
                        // Image left, text right
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: imageWidget,
                        ),
                        textWidget,
                      ],
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
