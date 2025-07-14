import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/profile_controller.dart';
import '../utils/app_colors.dart';

import 'product_list_page.dart';
import 'cart_page.dart';
import 'login_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC    = Get.find<AuthController>();
    final pc       = Get.find<ProductController>();
    final favC     = Get.find<FavoriteController>();
    final cartC    = Get.find<CartController>();
    final profileC = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    final path = profileC.imagePath.value;
                    return GestureDetector(
                      onTap: () async {
                        final should = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Fotoğraf Güncelle'),
                            content: const Text('Profil fotoğrafınızı galeriden seçmek ister misiniz?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hayır')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Evet')),
                            ],
                          ),
                        );
                        if (should == true) await profileC.pickImage();
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: path != null ? FileImage(File(path)) : null,
                        child: path == null
                            ? const Icon(Icons.person, size: 40, color: AppColors.primary)
                            : null,
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    authC.user.value?.email ?? '',
                    style: const TextStyle(color: Colors.white),
                  )),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Ürün Listesi'),
              onTap: () {
                Navigator.pop(context);
                Get.offAll(() => const ProductListPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('Favoriler'),
              onTap: () => Navigator.pop(context),
            ),
            Obx(() {
              final qty = cartC.cart.values.fold<int>(0, (s, q) => s + q);
              return ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Sepet'),
                trailing: qty > 0
                    ? CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text('$qty', style: const TextStyle(fontSize: 12, color: Colors.white)),
                )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const CartPage());
                },
              );
            }),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: () async {
                await authC.signOut();
                Get.offAll(() => const LoginPage());
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: Obx(() {
        final favIds = favC.favoriteIds;
        final favProducts = pc.products.where((p) => favIds.contains(p.id)).toList();

        if (favProducts.isEmpty) {
          return Center(
            child: Text('Henüz favori yok', style: TextStyle(color: AppColors.textDark)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          itemCount: favProducts.length,
          itemBuilder: (_, i) {
            final p = favProducts[i];
            return Card(
              key: ValueKey(p.id),
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(p.image, width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.star, color: Colors.amber),
                      onPressed: () => favC.toggleFavorite(p.id),
                    ),
                    // Sepet ikonu kaldırıldı
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
