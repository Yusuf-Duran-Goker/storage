// lib/pages/orders_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/bottom_nav_controller.dar.dart';
import '../controllers/order_controller.dart';
 // Bottom navigation controller import edildi
import '../utils/app_colors.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // OrderController'ı başlat veya bul
    final orderC = Get.put(OrderController());
    // Alt navigasyon kontrolcünüzü bulun
    final navC = Get.find<BottomNavController>();

    return WillPopScope(
      onWillPop: () async {
        // Android geri tuşuna basıldığında Profil sekmesine dön ve sayfayı kapat
        navC.changeIndex(3);
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Siparişlerim'),
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // AppBar geri tuşu için aynı davranış
              navC.changeIndex(3);
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          final orders = orderC.orders;
          if (orders.isEmpty) {
            return Center(
              child: Text(
                'Henüz sipariş bulunmuyor.',
                style: TextStyle(
                  color: AppColors.textDark.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final order = orders[index];
              final ts = order.timestamp.toLocal();
              final date = "\${ts.day.toString().padLeft(2, '0')}"
                  "/\${ts.month.toString().padLeft(2, '0')}"
                  "/\${ts.year} "
                  "\${ts.hour.toString().padLeft(2, '0')}"
                  ":\${ts.minute.toString().padLeft(2, '0')}";
              final itemCount = order.items.values.fold<int>(
                0, (sum, q) => sum + q,
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text('Sipariş #\${order.id.substring(0,8)}'),
                  subtitle: Text('\$date\n\$itemCount ürün'),
                  trailing: Text(
                    '\$\\${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
