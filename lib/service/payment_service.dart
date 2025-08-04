// lib/services/payment_service.dart

/// Basit bir ödeme servisi simülasyonu.
/// Gerçek Stripe entegrasyonu eklenecek.
class PaymentResult {
  final bool success;
  final String? message;

  PaymentResult({required this.success, this.message});
}

class PaymentService {
  /// Ödeme işleme fonksiyonu.
  /// Şu anda sadece 2 saniye bekleyip başarılı dönüyor.
  static Future<PaymentResult> processPayment(double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: Burada Stripe ödeme akışını entegre et.
    return PaymentResult(success: true);
  }
}
