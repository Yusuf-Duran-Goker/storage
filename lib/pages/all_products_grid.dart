import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/favorite_controller.dart';
import 'product_detail_page.dart';

class AllProductsGrid extends StatelessWidget {
  final String? searchQuery;

  const AllProductsGrid({
    Key? key,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pc   = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();
    final allProducts = pc.products;

    final products = (searchQuery != null && searchQuery!.isNotEmpty)
        ? allProducts
        .where((p) =>
    p.title.toLowerCase().contains(searchQuery!.toLowerCase()) ||
        p.category.toLowerCase().contains(searchQuery!.toLowerCase()))
        .toList()
        : allProducts;

    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final product = products[i];
        return GestureDetector(
          onTap: () {
            Get.to(() => ProductDetailPage(product: product));
          },
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          loadingBuilder: (c, child, progress) =>
                          progress == null
                              ? child
                              : const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    final isFav = favC.favoriteIds.contains(product.id);
                    return GestureDetector(
                      onTap: () => favC.toggleFavorite(product.id),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey.shade700,
                        size: 24,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
