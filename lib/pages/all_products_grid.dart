// lib/pages/all_products_grid.dart

import 'package:flutter/material.dart';
import 'package:storage/models/product_model.dart';
import 'package:storage/service/product_service.dart';

class AllProductsGrid extends StatelessWidget {
  /// Eğer bir arama sorgusu geldiyse buradan okuyoruz.
  final String? searchQuery;

  const AllProductsGrid({
    Key? key,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: ProductService().fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        }

        final allProducts = snapshot.data ?? [];
        final products = (searchQuery?.isNotEmpty == true)
            ? allProducts
            .where((p) => p.title
            .toLowerCase()
            .contains(searchQuery!.toLowerCase()))
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
            return Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('\$${product.price.toStringAsFixed(2)}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
