// lib/pages/favorites_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favC  = Get.find<FavoriteController>();
    final cartC = Get.find<CartController>();
    final pc    = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),
      body: Obx(() {
        // 1) Favori ID listesini al
        final favIds = favC.favorites;

        // 2) Tüm ürünler arasından favoriye ait modelleri seç
        final favProducts = pc.products
            .where((p) => favIds.contains(p.id))
            .toList();

        if (favProducts.isEmpty) {
          return const Center(child: Text('Henüz favori yok'));
        }

        // 3) Favori ürünleri listele
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: favProducts.length,
          separatorBuilder: (_, __) => const Divider(height: 32),
          itemBuilder: (context, i) {
            final p = favProducts[i];
            return ListTile(
              leading: Image.network(p.image, width: 50, height: 50),
              title: Text(p.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favoriden kaldır
                  IconButton(
                    icon: const Icon(Icons.star),
                    color: Colors.amber,
                    onPressed: () => favC.toggleFavorite(p),
                  ),
                  // Sepete ekle / durum
                  Obx(() {
                    final inCart = cartC.items.containsKey(p.id);
                    return IconButton(
                      icon: Icon(
                        inCart
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart,
                      ),
                      color: inCart ? Colors.green : null,
                      onPressed: () => cartC.addToCart(p),
                    );
                  }),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
