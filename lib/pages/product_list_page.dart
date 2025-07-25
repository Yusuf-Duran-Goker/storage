// lib/pages/product_list_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/profile_controller.dart';
import '../utils/app_colors.dart';

import 'product_detail_page.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import 'login_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC    = Get.find<AuthController>();
    final pc       = Get.find<ProductController>();
    final favC     = Get.find<FavoriteController>();
    final cartC    = Get.find<CartController>();
    final profileC = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Storage'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      // --- BURADAKİ KISMI GÜNCELLEDİK ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // margin ve padding sıfırlandı:
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(color: AppColors.primary),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                                TextButton(onPressed: () => Navigator.pop(context, true),  child: const Text('Evet')),
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Ürün Listesi'),
              onTap: () {
                Get.back();
                Get.offAll(() => const ProductListPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('Favoriler'),
              onTap: () {
                Get.back();
                Get.to(() => const FavoritesPage());
              },
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
                  child: Text(
                    '$qty',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
                    : null,
                onTap: () {
                  Get.back();
                  Get.to(() => const CartPage());
                },
              );
            }),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: () async {
                Get.back();
                await authC.signOut();
                Get.offAll(() => const LoginPage());
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
            // Kategori Chip’leri ...
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: pc.categories.map((c) {
                    final selected = pc.selectedCategory.value == c;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: selected,
                        onSelected: (_) => pc.selectedCategory.value = c,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Ürün Izgarası ...
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: pc.filteredProducts.length,
                itemBuilder: (_, i) {
                  final p = pc.filteredProducts[i];
                  return GestureDetector(
                    onTap: () => Get.to(() => ProductDetailPage(product: p)),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(p.image, fit: BoxFit.cover, width: double.infinity),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              p.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              '\$${p.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  final isFav = favC.isFavorite(p.id);
                                  return IconButton(
                                    icon: Icon(isFav ? Icons.star : Icons.star_border),
                                    color: isFav ? Colors.amber : Colors.grey,
                                    onPressed: () => favC.toggleFavorite(p.id),
                                  );
                                }),
                                Obx(() {
                                  final inCart = cartC.contains(p.id);
                                  return IconButton(
                                    icon: Icon(inCart
                                        ? Icons.remove_shopping_cart
                                        : Icons.add_shopping_cart),
                                    color: inCart ? Colors.red : null,
                                    onPressed: () => inCart
                                        ? cartC.removeFromCart(p.id)
                                        : cartC.addToCart(p.id),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
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
