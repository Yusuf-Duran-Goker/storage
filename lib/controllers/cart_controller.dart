import 'package:get/get.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  // Product → adet
  var items = <Product, int>{}.obs;

  void addToCart(Product p) {
    items[p] = (items[p] ?? 0) + 1;
  }

  void removeFromCart(Product p) {
    final count = items[p] ?? 0;
    if (count > 1) {
      items[p] = count - 1;
    } else {
      items.remove(p);
    }
  }

  double get totalPrice => items.entries
      .map((e) => e.key.price * e.value)
      .fold(0.0, (sum, v) => sum + v);
}
