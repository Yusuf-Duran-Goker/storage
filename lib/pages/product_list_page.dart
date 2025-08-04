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
  final String? searchQuery;
  final bool hideAppBar;

  const ProductListPage({
    Key? key,
    this.searchQuery,
    this.hideAppBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kullanıcı bilgileri
    final uc = Get.find<UserController>();
    final profile = uc.profile.value ?? {};
    final rawName = (profile['firstName'] as String?)
        ?? uc.firebaseUser.value?.email?.split('@').first
        ?? '';
    final name = rawName.isNotEmpty
        ? rawName[0].toUpperCase() + rawName.substring(1)
        : '';
    final photoUrl = profile['photoUrl'] as String?;

    // Controller'lar
    final pc = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();
    // Banner için görseller
    final banners = pc.products.take(5).map((p) => p.image).toList();

    return DefaultTabController(
      length: hideAppBar ? 1 : 2,
      child: Scaffold(
        body: Column(
          children: [
            if (!hideAppBar)
              Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TabBar(
                  // Alt çizgi rengi ve kalınlığı
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  // Seçili ve seçilmeyen sekme yazı renkleri
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textDark.withOpacity(0.6),
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Category'),
                  ],
                ),
              ),
            Expanded(
              child: hideAppBar
                  ? const AllProductsPage()
                  : TabBarView(
                children: [
                  // All tab
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BannerSlider(imageUrls: banners),
                        const SizedBox(height: 16),
                        const NewArrivalsSection(),
                        const SizedBox(height: 16),
                        _PreviewGrid(),
                      ],
                    ),
                  ),
                  // Category tab
                  const CategoryPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PreviewGrid widget to display first 6 products in home
class _PreviewGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProductController>();
    final favC = Get.find<FavoriteController>();
    final previewProducts = pc.products.take(6).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: previewProducts.length,
        itemBuilder: (context, i) {
          final p = previewProducts[i];
          return GestureDetector(
            onTap: () => Get.to(() => ProductDetailPage(product: p)),
            child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            p.image,
                            fit: BoxFit.cover,
                            loadingBuilder: (c, child, progress) =>
                            progress == null
                                ? child
                                : const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.broken_image)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\$${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(() {
                      final isFav = favC.favoriteIds.contains(p.id);
                      return GestureDetector(
                        onTap: () => favC.toggleFavorite(p.id),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey.shade700,
                          size: 24,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
