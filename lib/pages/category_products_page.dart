// lib/pages/category_products_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'product_detail_page.dart';   // ★ Detay sayfası importu

class CategoryProductsPage extends StatelessWidget {
  final String category;
  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProductController>();
    final products = pc.products.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category[0].toUpperCase() + category.substring(1)),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products found.'))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () {
              // Kategori listesinden ürüne tıklanınca detay sayfasına geç
              Get.to(() => ProductDetailPage(product: p));
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    p.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, prog) {
                      if (prog == null) return child;
                      return const SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (_, __, ___) =>
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                title: Text(
                  p.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Fiyatı yeşil renkte gösterecek şekilde güncellendi
                subtitle: Text(
                  '\$${p.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
