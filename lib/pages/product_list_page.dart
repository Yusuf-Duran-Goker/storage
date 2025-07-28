// lib/pages/product_list_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/pages/all_products_grid.dart';
import 'package:storage/pages/category_page.dart';
import 'package:storage/controllers/user_controller.dart';
import 'package:storage/pages/product_search_delegate.dart';

class ProductListPage extends StatelessWidget {
  final String? searchQuery;
  final bool hideAppBar;

  const ProductListPage({
    Key? key,
    this.searchQuery,
    this.hideAppBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uc       = Get.find<UserController>();
    final profile  = uc.profile.value ?? {};
    final rawName  = (profile['firstName'] as String?)
        ?? uc.firebaseUser.value?.email?.split('@').first
        ?? '';
    final name     = rawName.isNotEmpty
        ? rawName[0].toUpperCase() + rawName.substring(1)
        : '';
    final photoUrl = profile['photoUrl'] as String?;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            // Put the TabBar at the top of the body instead:
            Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const TabBar(
                indicatorColor: Colors.blue,      // style as you like
                labelColor: Colors.blue,          // style as you like
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Category'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  AllProductsGrid(searchQuery: searchQuery),
                  const CategoryPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
