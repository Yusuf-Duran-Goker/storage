// lib/pages/product_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/auth_controller.dart';
import 'package:storage/controllers/cart_controller.dart';
import 'package:storage/controllers/favorite_controller.dart';
import 'package:storage/controllers/product_controller.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import 'login_register_page.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final pc    = Get.put(ProductController());
    final favC  = Get.put(FavoriteController());
    final cartC = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Storage'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Menü',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),

            // Favoriler
            ListTile(
              leading: const Icon(Icons.star),
              title: const Center(child: Text('Favoriler')),
              onTap: () => Get.to(() => FavoritesPage()),
            ),

            // Sepet (badge)
            Obx(() {
              final totalQty = cartC.items.values.fold<int>(0, (s, q) => s + q);
              return ListTile(
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (totalQty > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$totalQty',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: const Center(child: Text('Sepet')),
                onTap: () => Get.to(() => CartPage()),
              );
            }),

            // Spacer ile Log Out'u en alta itiyoruz
            const Spacer(),

            // Log Out öğesi
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Center(child: Text('Log Out')),
              onTap: () async {
                await authC.signOut();
                Get.offAll(() => LoginRegisterPage());
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),

      body: Obx(() {
        if (pc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (pc.error.value.isNotEmpty) {
          return Center(child: Text('Hata: ${pc.error.value}'));
        }
        return Column(
          children: [
            // Kategori filtresi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                value: pc.selectedCategory.value,
                items: pc.categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) pc.selectedCategory.value = v;
                },
              ),
            ),

            // Ürün listesi
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: pc.filteredProducts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final p = pc.filteredProducts[i];
                  return Card(
                    child: InkWell(
                      onTap: () => Get.to(() => ProductDetailPage(product: p)),
                      child: ListTile(
                        leading: Image.network(p.image, width: 50, height: 50),
                        title: Text(p.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              final isFav = favC.isFavorite(p);
                              return IconButton(
                                icon: Icon(
                                  isFav ? Icons.star : Icons.star_border,
                                  color: isFav ? Colors.amber : Colors.grey,
                                ),
                                onPressed: () => favC.toggleFavorite(p),
                              );
                            }),
                            Obx(() {
                              final inCart = cartC.items.containsKey(p);
                              return IconButton(
                                icon: Icon(
                                  inCart
                                      ? Icons.shopping_cart
                                      : Icons.add_shopping_cart,
                                  color: inCart ? Colors.green : null,
                                ),
                                onPressed: () => cartC.addToCart(p),
                              );
                            }),
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
      }),
    );
  }
}
