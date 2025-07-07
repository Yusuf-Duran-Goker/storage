// lib/utils/app_colors.dart

import 'package:flutter/material.dart';

/// Uygulamanın renk paleti
class AppColors {
  AppColors._(); // Instancelanmasın

  /// Ana vurgu rengi (butonlar, başlıklar vb.)
  static const Color primary = Color(0xFF2196F3);

  /// İkinci vurgu rengi (secondary buttons vb.)
  static const Color secondary = Color(0xFF90CAF9);

  /// Yardımcı vurgu rengi (accent, hata mesajı vb.)
  static const Color accent = Color(0xFFFF9800);

  /// Çok açık bi ton — gradient’lerde üst kısım için
  static const Color lightGradientTop = Color(0x332196F3);

  /// Çok açık bi ton — gradient’lerde alt kısım için
  static const Color lightGradientBottom = Color(0x3390CAF9);

  /// Koyu metin rengi (buton metinleri, başlıklar vb.)
  static const Color textDark = Colors.black87;

  /// Scaffold arkaplan rengi
  static const Color scaffoldBg = Colors.white;

  /// Hata rengi (snackbar vb.)
  static const Color error = Colors.redAccent;
}
