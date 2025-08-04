import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/cart_controller.dart';
import 'package:storage/controllers/favorite_controller.dart';
import '../models/product_model.dart';
import '../utils/app_colors.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final cartC = Get.find<CartController>();
  final favC  = Get.find<FavoriteController>();

  Color _selectedColor = AppColors.primary;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final existing = cartC.cart[widget.product.id] ?? 0;
    _quantity = existing > 0 ? existing : 1;
  }

  Widget _colorDot(Color color) {
    final isSelected = color == _selectedColor;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: isSelected ? 28 : 24,
        height: isSelected ? 28 : 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: AppColors.accent, width: 2)
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Obx(() => InkWell(
              onTap: () => favC.toggleFavorite(product.id),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  favC.isFavorite(product.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 20,
                  color: favC.isFavorite(product.id)
                      ? Colors.red
                      : Colors.grey.shade600,
                ),
              ),
            )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Yeşil olarak güncellendi
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text('4.8 (320)', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                          ),
                          Text('$_quantity', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _colorDot(AppColors.primary),
                      _colorDot(Colors.black),
                      _colorDot(Colors.cyan),
                      _colorDot(Colors.green),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        product.description,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ),
                  Obx(() {
                    final inCart = cartC.cart[product.id] ?? 0;
                    return ElevatedButton.icon(
                      onPressed: () {
                        if (_quantity > inCart) {
                          for (int i = 0; i < _quantity - inCart; i++) {
                            cartC.addToCart(product.id);
                          }
                        } else if (_quantity < inCart) {
                          for (int i = 0; i < inCart - _quantity; i++) {
                            cartC.removeFromCart(product.id);
                          }
                        }
                      },
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      label: Text('Add $_quantity to Cart', style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
