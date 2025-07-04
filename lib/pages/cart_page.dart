// lib/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartC = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sepet')),
      body: Obx(() {
        if (cartC.items.isEmpty) {
          return const Center(child: Text('Sepetiniz boş'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartC.items.length,
                itemBuilder: (_, idx) {
                  final prod = cartC.items.keys.elementAt(idx);
                  final qty  = cartC.items.values.elementAt(idx);
                  return ListTile(
                    leading: Image.network(prod.image, width: 50, height: 50),
                    title: Text(prod.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('\$${prod.price.toStringAsFixed(2)} x $qty'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => cartC.removeFromCart(prod),
                        ),
                        Text('$qty'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => cartC.addToCart(prod),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Toplam fiyat
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                return Text(
                  'Toplam: \$${cartC.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
