import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LangController extends Translations {
  final _storage = GetStorage();
  final locale = Locale('tr', 'TR').obs;

  static const String storageKey = 'language';

  @override
  Map<String, Map<String, String>> get keys => {
    'tr_TR': {
      'hello': 'Merhaba',
      'profile': 'Profil',
      'settings': 'Ayarlar',
      'edit_profile': 'Profili Düzenle',
      'language': 'Dil',
      'select_language': 'Dil Seçimi',
      'logout': 'Çıkış Yap',
      // Diğer çeviriler burada
    },
    'en_US': {
      'hello': 'Hello',
      'profile': 'Profile',
      'settings': 'Settings',
      'edit_profile': 'Edit Profile',
      'language': 'Language',
      'select_language': 'Select Language',
      'logout': 'Logout',
      // Diğer çeviriler burada
    },
  };

  LangController() {
    _loadLocale();
  }

  void _loadLocale() {
    final savedLangCode = _storage.read(storageKey) ?? 'tr_TR';
    locale.value = _localeFromString(savedLangCode);
    Get.updateLocale(locale.value);
  }

  void changeLocale(Locale newLocale) {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
    _storage.write(storageKey, '${newLocale.languageCode}_${newLocale.countryCode}');
  }

  Locale _localeFromString(String val) {
    final parts = val.split('_');
    if (parts.length != 2) {
      return const Locale('tr', 'TR');
    }
    return Locale(parts[0], parts[1]);
  }
}
