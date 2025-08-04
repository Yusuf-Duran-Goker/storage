import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/service/order_service.dart';               // ← ekledik
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../utils/app_colors.dart';
import 'cart_item_card.dart';
import 'orders_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartC = Get.find<CartController>();
  final pc    = Get.find<ProductController>();
  final _orderService = OrderService();      // ← ekledik
  bool _isProcessing = false;

  Future<void> _confirmOrder(double total) async {
    setState(() => _isProcessing = true);
    try {
      // 1) Firestore’a siparişi kaydet
      await _orderService.createOrder(cartC.cart, total);
      // 2) Sepeti temizle
      await cartC.clearCart();
      // 3) Siparişler sayfasına yönlendir
      Get.off(() => const OrdersPage());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sipariş hatası: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        /* ... geri kalan AppBar ayarları ... */
      ),
      body: Obx(() {
        final entries = cartC.cart.entries.toList();
        if (entries.isEmpty) {
          return Center(
            child: Text('Sepetiniz boş',
                style: TextStyle(color: AppColors.textDark.withOpacity(0.6))),
          );
        }
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (_, i) {
            final id = entries[i].key;
            final qty = entries[i].value;
            final p = pc.products.firstWhere((x) => x.id == id);
            return CartItemCard(product: p, quantity: qty);
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        final entries = cartC.cart.entries.toList();
        if (entries.isEmpty) return const SizedBox();
        final subtotal = entries.fold<double>(
            0, (sum, e) =>
        sum + pc.products.firstWhere((p) => p.id == e.key).price * e.value);
        const shipping = 6.0;
        final total = subtotal + shipping;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3)) ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            /* … promo kod ve fiyat satırları … */
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isProcessing ? null : () => _confirmOrder(total),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isProcessing
                  ? const SizedBox(
                height: 24, width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : const Text('Siparişi Onayla', style: TextStyle(color: Colors.white)),
            ),
          ]),
        );
      }),
    );
  }
}
