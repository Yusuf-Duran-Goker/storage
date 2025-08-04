import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentApi {
  /// Cloud Function URL’unuzu buraya yapıştırın:
  static const _endpoint = 'https://us-central1-storege-9e7e7.cloudfunctions.net/api/createPaymentIntent';

  /// total: USD cinsinden (örn. 12.34)
  static Future<String> createPaymentIntent(double total) async {
    final resp = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': total}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Sunucudan yanıt alınamadı: ${resp.body}');
    }
    final data = jsonDecode(resp.body);
    return data['clientSecret'] as String;
  }
}
