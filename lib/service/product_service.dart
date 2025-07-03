import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storage/models/product_model.dart';


class ProductService {
  static const _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$_baseUrl/products'));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Ürünler yüklenemedi: ${res.statusCode}');
    }
  }
}
