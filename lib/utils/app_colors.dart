// lib/utils/app_colors.dart

import 'package:flutter/material.dart';

/// Uygulamanın renk paleti (Trendyol × Temu)
class AppColors {
  AppColors._();

  /// Trendyol Turuncusu
  static const Color primary = Color(0xFFFF6D00);

  /// Yüzey rengi (kart, panel arkaplanı)
  static const Color secondary = Color(0xFFF5F5F5);

  /// Temu Kırmızısı (vurgular, seçili durumlar)
  static const Color accent = Color(0xFFFF2100);

  /// Gradient üst — primary’nin %20 opak hâli
  static const Color lightGradientTop = Color(0x33FF6D00);

  /// Gradient alt — accent’in %20 opak hâli
  static const Color lightGradientBottom = Color(0x33FF2100);

  /// Koyu metin rengi
  static const Color textDark = Color(0xFF212121);

  /// Scaffold arkaplan rengi
  static const Color scaffoldBg = Color(0xFFFFFFFF);

  /// Hata rengi (snackbar vb.)
  static const Color error = Colors.redAccent;
}
