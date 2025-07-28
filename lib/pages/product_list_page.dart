// lib/pages/product_list_page.dart

import 'package:flutter/material.dart';
import 'package:storage/pages/all_products_grid.dart';  // ← burayı ekledik
import 'category_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // “All” ve “Category”
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Products'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Category'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllProductsGrid(),   // ← artık burda referans
            CategoryPage(),
          ],
        ),
      ),
    );
  }
}
