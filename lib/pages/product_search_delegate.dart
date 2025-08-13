// lib/pages/product_search_delegate.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/product_controller.dart';
import 'product_detail_page.dart';
import '../utils/app_colors.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  bool _showingResults = false;

  @override
  String get searchFieldLabel => 'Search products...';

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _showingResults = false;
          showSuggestions(context);
        },
      ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      if (_showingResults) {
        _showingResults = false;
        showSuggestions(context);
      } else {
        close(context, '');
      }
    },
  );

  @override
  void showResults(BuildContext context) {
    _showingResults = true;
    super.showResults(context);
  }

  @override
  void showSuggestions(BuildContext context) {
    _showingResults = false;
    super.showSuggestions(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    final pc = Get.find<ProductController>();
    final q = query.toLowerCase();
    final results = pc.products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: TextStyle(color: AppColors.textDark.withOpacity(0.6)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final p = results[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: p),
              ),
            ),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildSafeImage(p.image, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Search',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final term = ['Electronics', 'Shirts', 'Bag', 'Jacket'][i];
                    return ChoiceChip(
                      label: Text(term),
                      selected: false,
                      onSelected: (_) {
                        query = term;
                        showResults(context);
                      },
                      backgroundColor: AppColors.secondary,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(color: AppColors.textDark),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Popular Search',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length >= 4 ? 4 : products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final badge = ['Hot', 'New', 'Popular']
                    [product['title'].hashCode % 3];
                    return Card(
                      color: AppColors.scaffoldBg,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildSafeImage(
                              (product['image'] as String?) ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover),
                        ),
                        title: Text(
                          product['title'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          badge,
                          style:
                          TextStyle(color: AppColors.accent, fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            query = product['title'];
                            showResults(context);
                          },
                        ),
                        onTap: () {
                          query = product['title'];
                          showResults(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<dynamic>> _fetchProducts() async {
    final response =
    await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }

  /// Geçersiz URL’lerde fallback gösterir
  Widget _buildSafeImage(
      String url, {
        double? width,
        double? height,
        BoxFit? fit,
      }) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (c, child, prog) =>
        prog == null ? child : const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, __, ___) =>
        const Center(child: Icon(Icons.broken_image)),
      );
    }
    // placeholder olarak bir asset veya boş container
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
