// lib/controllers/product_controller.dart

import 'package:get/get.dart';
import 'package:storage/models/product_model.dart';
import 'package:storage/service/product_service.dart';           // ← Orijinal servis
import 'package:storage/service/reactbd_product_service.dart';  // ← Yeni servis

class ProductController extends GetxController {
  // İki farklı servisi de tanımlıyoruz
  final _fakeService    = ProductService();           // <-- Burada ProductService
  final _reactBdService = ReactBdProductService();

  // Reaktif state
  var products         = <Product>[].obs;
  var categories       = <String>[].obs;
  var selectedCategory = 'All'.obs;
  var isLoading        = false.obs;
  var error            = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  /// Hem fakestoreapi.com hem de reactbd.org’dan ürünleri çekip birleştirir
  Future<void> fetchAllProducts() async {
    isLoading.value = true;
    error.value     = '';
    try {
      // 1) fakestoreapi.com’dan
      final list1 = await _fakeService.fetchProducts();
      // 2) reactbd.org’dan
      final list2 = await _reactBdService.fetchProducts();

      // İki listeyi birleştir
      final combined = [...list1, ...list2];
      products.assignAll(combined);

      // Kategorileri oluştur
      final cats = combined.map((p) => p.category).toSet().toList();
      categories.assignAll(['All', ...cats]);

      // Varsayılan kategori
      selectedCategory.value = 'All';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Seçilen kategoriye göre filtrelenmiş ürünler
  List<Product> get filteredProducts {
    if (selectedCategory.value == 'All') {
      return products;
    }
    return products
        .where((p) => p.category == selectedCategory.value)
        .toList();
  }
}
