import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/favorite_controller.dart';
import '../utils/app_colors.dart';
import '../pages/all_products_page.dart';
import '../pages/category_page.dart';
import '../pages/product_detail_page.dart';
import 'banner_slider.dart';
import 'new_arrivals_section.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uc   = Get.find<UserController>();
    final pc   = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();
    final banners = pc.products.take(5).map((p) => p.image).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textDark.withOpacity(0.6),
              tabs: const [Tab(text: 'All'), Tab(text: 'Category')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        BannerSlider(imageUrls: banners),
                        SizedBox(height: 16),
                        NewArrivalsSection(),
                        SizedBox(height: 16),
                        _PreviewGrid(),
                      ],
                    ),
                  ),
                  CategoryPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pc   = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();
    final list = pc.products.take(6).toList();

    return GridView.builder(
      shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.75,
        crossAxisSpacing: 8, mainAxisSpacing: 8,
      ),
      itemCount: list.length,
      itemBuilder: (c,i) {
        final p = list[i];
        return GestureDetector(
          onTap: () => Get.to(() => ProductDetailPage(product: p)),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(p.image, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('\$${p.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Obx(() {
                    final fav = favC.favoriteIds.contains(p.id);
                    return IconButton(
                      icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                          color: fav ? Colors.red : Colors.grey),
                      onPressed: () => favC.toggleFavorite(p.id),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
