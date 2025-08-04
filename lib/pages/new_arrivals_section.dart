import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/pages/product_detail_page.dart';
import '../controllers/product_controller.dart';
import '../pages/all_products_page.dart';  // Güncellendi: AllProductsGrid yerine AllProductsPage import ediliyor

class NewArrivalsSection extends StatelessWidget {
  const NewArrivalsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProductController>();
    final all = pc.products;
    // Son eklenen 6 ürünü alıyoruz:
    final newArrivals = all.reversed.take(6).toList();

    if (newArrivals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Arrivals 🔥',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Get.to(() => const AllProductsPage()),  // Güncellendi: AllProductsPage'e yönlendiriyor
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 260,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: newArrivals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final p = newArrivals[i];
              return SizedBox(
                width: 160,
                child: GestureDetector(
                  onTap: () => Get.to(() => ProductDetailPage(product: p)),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            p.image,
                            fit: BoxFit.cover,
                            loadingBuilder: (c, child, progress) =>
                            progress == null ? child : const Center(child: CircularProgressIndicator()),
                            errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            p.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${p.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
