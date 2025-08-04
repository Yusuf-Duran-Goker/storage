import 'package:flutter/material.dart';
import 'all_products_grid.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const AllProductsGrid(),
    );
  }
}
