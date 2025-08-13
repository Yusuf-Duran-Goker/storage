import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'product_detail_page.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;
  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProductController>();
    final lower = category.toLowerCase();

    // case-insensitive filtre
    final products = pc.products
        .where((p) => p.category.toLowerCase() == lower)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: products.isEmpty
          ? const Center(child: Text('No products found.'))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () => Get.to(() => ProductDetailPage(product: p)),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    p.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, prog) =>
                    prog == null ? child : const SizedBox(
                      width: 50, height: 50,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorBuilder: (_, __, ___) =>
                    const SizedBox(
                      width: 50, height: 50,
                      child: Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ),
            ),
          );
        },
      ),
    );
  }
}
