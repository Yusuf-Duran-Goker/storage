import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/cart_controller.dart';
import 'login_page.dart';          // ← eski LoginRegisterPage yerine
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final pc    = Get.put(ProductController());
    final favC  = Get.put(FavoriteController());
    final cartC = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Listesi')),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text('Menü',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
            // ...
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                await authC.signOut();
                // artık doğru sınıf ismi
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
        // … ürün listesi aynı
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pc.filteredProducts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) {
            final p = pc.filteredProducts[i];
            return Card(
              child: ListTile(
                onTap: () => Get.to(() => ProductDetailPage(product: p)),
                title: Text(p.title),
                // …
              ),
            );
          },
        );
      }),
    );
  }
}
