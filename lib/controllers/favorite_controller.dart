import 'package:get/get.dart';
import 'package:storage/models/product_model.dart';


class FavoriteController extends GetxController {
  // Favoriler listesi
  var favorites = <Product>[].obs;

  // Bir ürün favoride mi?
  bool isFavorite(Product p) => favorites.any((x) => x.id == p.id);

  // Toggle et
  void toggleFavorite(Product p) {
    if (isFavorite(p)) {
      favorites.removeWhere((x) => x.id == p.id);
    } else {
      favorites.add(p);
    }
  }
}
