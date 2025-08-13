// --- imports aynı kalabilir ---
import 'package:get/get.dart';
import 'package:storage/models/product_model.dart';
import 'package:storage/service/product_service.dart';
import 'package:storage/service/reactbd_product_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController extends GetxController {
  final _fakeService    = ProductService();
  final _reactBdService = ReactBdProductService();

  var apiProducts       = <Product>[].obs;
  var reactProducts     = <Product>[].obs;

  // NEW: Admin/global products from Firestore /products
  var adminProducts     = <Product>[].obs;

  var products          = <Product>[].obs;
  var categories        = <String>[].obs;
  var selectedCategory  = 'All'.obs;
  var isLoading         = false.obs;
  var error             = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
    _listenAdminProducts(); // NEW
  }

  Future<void> fetchAllProducts() async {
    isLoading.value = true;
    error.value     = '';
    try {
      final list1 = await _fakeService.fetchProducts();
      final list2 = await _reactBdService.fetchProducts();
      apiProducts.assignAll(list1);
      reactProducts.assignAll(list2);
      _mergeProducts();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: listen to /products (admin’in ekledikleri dahil herkesin göreceği liste)
  void _listenAdminProducts() {
    FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Not: 'id' alanını Firestore'da numeric olarak tutacağız (aşağıdaki addProduct bak)
        return Product.fromJson({
          ...data,
        });
      }).toList();
      adminProducts.assignAll(list);
      _mergeProducts();
    });
  }

  void _mergeProducts() {
    final combined = [...apiProducts, ...reactProducts, ...adminProducts];
    products.assignAll(combined);

    final cats = combined
        .map((p) => p.category)
        .where((c) => c.isNotEmpty)
        .map((c) => c[0].toUpperCase() + c.substring(1))
        .toSet()
        .toList();
    categories.assignAll(['All', ...cats]);

    if (!categories.contains(selectedCategory.value)) {
      selectedCategory.value = 'All';
    }
  }

  /// NEW: Admin ürün ekleme -> /products
  Future<void> addProduct(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final numericId = DateTime.now().millisecondsSinceEpoch; // Product.id için
    await FirebaseFirestore.instance.collection('products').add({
      'id'         : numericId,                // <-- INT id (favoriler için stabil)
      'title'      : product.title,
      'description': product.description,
      'price'      : product.price,
      'category'   : product.category,
      'imageUrl'   : product.image,            // model image|imageUrl ikisini de okuyor
      'rating'     : {
        'rate' : product.rating,
        'count': product.ratingCount,
      },
      'ownerId'    : user.uid,
      'createdAt'  : FieldValue.serverTimestamp(),
    });
  }
}
