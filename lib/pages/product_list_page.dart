// lib/pages/product_list_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/profile_controller.dart';

import 'product_detail_page.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import 'login_register_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC    = Get.find<AuthController>();
    final pc       = Get.put(ProductController());
    final favC     = Get.put(FavoriteController());
    final cartC    = Get.put(CartController());
    final profileC = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Storage'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Profil bilgilerini gösteren tıklanabilir header
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              padding: EdgeInsets.zero,
              child: InkWell(
                onTap: () => profileC.pickImage(),
                child: Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        final path = profileC.imagePath.value;
                        return CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage:
                          path != null ? FileImage(File(path)) : null,
                          child: path == null
                              ? const Icon(Icons.person, size: 40, color: Colors.blue)
                              : null,
                        );
                      }),
                      const SizedBox(height: 8),
                      Text(
                        authC.user.value?.email ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Favoriler
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favoriler'),
              onTap: () => Get.to(() => const FavoritesPage()),
            ),

            // Sepet (badge ile)
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
                            style: const TextStyle(fontSize: 10, color: Colors.white, height: 1),
                          ),
                        ),
                      ),
                  ],
                ),
                title: const Text('Sepet'),
                onTap: () => Get.to(() => const CartPage()),
              );
            }),

            const Divider(),

            // Log Out en altta
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                await authC.signOut();
                Get.offAll(() => const LoginRegisterPage());
              },
            ),
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
                        title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              final isFav = favC.isFavorite(p);
                              return IconButton(
                                icon: Icon(isFav ? Icons.star : Icons.star_border),
                                color: isFav ? Colors.amber : Colors.grey,
                                onPressed: () => favC.toggleFavorite(p),
                              );
                            }),
                            Obx(() {
                              final inCart = cartC.items.containsKey(p);
                              return IconButton(
                                icon: Icon(inCart ? Icons.shopping_cart : Icons.add_shopping_cart),
                                color: inCart ? Colors.green : null,
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
