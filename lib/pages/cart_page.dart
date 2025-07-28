import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import 'package:storage/utils/app_colors.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartC = Get.find<CartController>();
    final pc    = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepet'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        final entries = cartC.cart.entries.toList();
        if (entries.isEmpty) {
          return Center(child: Text('Sepetiniz boş', style: TextStyle(color: AppColors.textDark)));
        }
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (_, i) {
            final id  = entries[i].key;
            final qty = entries[i].value;
            final p   = pc.products.firstWhere((x) => x.id == id);
            return ListTile(
              leading: Image.network(p.image, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('Adet: $qty'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: () => cartC.removeFromCart(id)),
                  IconButton(icon: const Icon(Icons.add),    onPressed: () => cartC.addToCart(id)),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        final total = cartC.cart.entries.fold<double>(0.0, (sum, e) {
          final p = pc.products.firstWhere((x) => x.id == e.key);
          return sum + p.price * e.value;
        });
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Text(
            'Toplam: \$${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }
}
