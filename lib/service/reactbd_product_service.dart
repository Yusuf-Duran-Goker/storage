// lib/service/reactbd_product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ReactBdProductService {
  final _baseUrl = 'https://fakestoreapiserver.reactbd.org/api';

  Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$_baseUrl/products'));
    if (res.statusCode != 200) {
      throw Exception('ReactBD API hatası: ${res.statusCode}');
    }

    final jsonBody = json.decode(res.body);

    // 1) JSON doğrudan liste ise
    if (jsonBody is List) {
      return (jsonBody as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // 2) JSON nesne ise: içinde 'products' veya 'data' gibi bir liste arıyoruz
    if (jsonBody is Map<String, dynamic>) {
      // örneğin { products: [ ... ] }
      if (jsonBody['products'] is List) {
        return (jsonBody['products'] as List)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      // veya { data: [ ... ] }
      if (jsonBody['data'] is List) {
        return (jsonBody['data'] as List)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    // Hiçbiri tutmadıysa hata fırlat
    throw Exception('Beklenmeyen JSON formatı: ${res.body}');
  }
}
