// lib/pages/product_search_delegate.dart

import 'package:flutter/material.dart';
import 'product_list_page.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search products...';

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) {
    // Burada artık hideAppBar: true geçiyoruz:
    return ProductListPage(
      searchQuery: query,
      hideAppBar: true,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ProductListPage(
      searchQuery: query,
      hideAppBar: true,
    );
  }
}
