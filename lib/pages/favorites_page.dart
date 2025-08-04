import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/favorite_controller.dart';
import '../utils/app_colors.dart';
import '../pages/product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pc   = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Obx(() {
        final favIds = favC.favoriteIds;
        final favProducts = pc.products.where((p) => favIds.contains(p.id)).toList();

        if (favProducts.isEmpty) {
          return Center(
            child: Text(
              'No favorites yet',
              style: TextStyle(color: AppColors.textDark.withOpacity(0.6)),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: favProducts.length,
          itemBuilder: (context, index) {
            final p = favProducts[index];
            return GestureDetector(
              onTap: () => Get.to(() => ProductDetailPage(product: p)),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            p.image,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => favC.toggleFavorite(p.id),
                            child: Icon(
                              favC.favoriteIds.contains(p.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favC.favoriteIds.contains(p.id)
                                  ? AppColors.accent
                                  : AppColors.textDark.withOpacity(0.6),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Upbox Bag',
                            style: TextStyle(
                              color: AppColors.textDark.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Fiyat rengi yeşil olarak güncellendi
                          Text(
                            '\$${p.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    )
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
