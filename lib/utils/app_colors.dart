// lib/utils/app_colors.dart

import 'package:flutter/material.dart';

/// Uygulamanın renk paleti (Clean Commerce)
class AppColors {
  AppColors._();

  /// Ana vurgu rengi (Steel Blue)
  static const Color primary = Color(0xFF4682B4);

  /// İkinci vurgu rengi (Cool Gray)
  static const Color secondary = Color(0xFFD3D3D3);

  /// Accent rengi (Mustard)
  static const Color accent = Color(0xFFFFC107);

  /// Gradient üst — primary’nin %20 opak hâli
  static const Color lightGradientTop = Color(0x334682B4);

  /// Gradient alt — secondary’nin %20 opak hâli
  static const Color lightGradientBottom = Color(0x20D3D3D3);

  /// Koyu metin rengi
  static const Color textDark = Color(0xFF212121);

  /// Scaffold arkaplan rengi
  static const Color scaffoldBg = Color(0xFFFFFFFF);

  /// Hata rengi (snackbar vb.)
  static const Color error = Colors.redAccent;
}
