import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/favorite_controller.dart';
import '../utils/app_colors.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pc   = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(() {
        final favIds = favC.favoriteIds;
        final favProducts = pc.products.where((p) => favIds.contains(p.id)).toList();

        if (favProducts.isEmpty) {
          return Center(
            child: Text(
              'Henüz favori yok',
              style: TextStyle(color: AppColors.textDark),
            ),
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
                      child: Image.network(
                        p.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${p.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => favC.toggleFavorite(p.id),
                    ),
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
