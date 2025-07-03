// lib/pages/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import '../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  // Login ekranındaki buton rengi
  static const buttonColor = Color(0xFF90CAF9);

  @override
  Widget build(BuildContext context) {
    final favC  = Get.find<FavoriteController>();
    final cartC = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(product.image, height: 250, fit: BoxFit.contain),
              const SizedBox(height: 16),
              Text(product.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, color: Colors.green)),
              const SizedBox(height: 16),
              Text(product.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),

              Row(
                children: [
                  Obx(() {
                    final isFav = favC.isFavorite(product);
                    return IconButton(
                      iconSize: 32,
                      icon: Icon(
                        isFav ? Icons.star : Icons.star_border,
                        color: isFav ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () => favC.toggleFavorite(product),
                    );
                  }),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.black87),
                      label: const Text('Sepete Ekle',
                          style: TextStyle(color: Colors.black87, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        cartC.addToCart(product);
                        Get.snackbar(
                          'Sepete Eklendi',
                          product.title,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
