// lib/pages/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/cart_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favC  = Get.find<FavoriteController>();
    final cartC = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),
      body: Obx(() {
        final list = favC.favorites;
        if (list.isEmpty) {
          return const Center(child: Text('Henüz favori yok'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) =>
          const Divider(height: 32),
          itemBuilder: (context, i) {
            final p = list[i];
            return ListTile(
              leading: Image.network(p.image,
                  width: 50, height: 50),
              title: Text(p.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favoriden Kaldır
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () =>
                        favC.toggleFavorite(p),
                  ),
                  // Sepete Ekle / Durum
                  Obx(() {
                    final inCart =
                    cartC.items.containsKey(p);
                    return IconButton(
                      icon: Icon(
                        inCart
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart,
                        color: inCart
                            ? Colors.green
                            : null,
                      ),
                      onPressed: () =>
                          cartC.addToCart(p),
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
