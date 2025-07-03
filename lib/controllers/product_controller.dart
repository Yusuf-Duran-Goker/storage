import 'package:get/get.dart';
import 'package:storage/models/product_model.dart';
import 'package:storage/service/product_service.dart';



class ProductController extends GetxController {
  final ProductService _service = ProductService();

  var products = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = 'All'.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final list = await _service.fetchProducts();
      products.assignAll(list);
      // Kategorileri “All” da dahil ederek çıkar
      categories.assignAll(['All', ...{for (var p in list) p.category}]);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Seçili kategoriye göre filtrelenmiş ürünler
  List<Product> get filteredProducts {
    if (selectedCategory.value == 'All') return products;
    return products.where((p) => p.category == selectedCategory.value).toList();
  }
}
