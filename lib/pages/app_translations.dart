// lib/translations/app_translations.dart

import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'tr': {
      'profile': 'Profil',
      'edit_profile': 'Profili Düzenle',
      'language': 'Uygulama Dili',
      'settings': 'Ayarlar',
      'videos': 'Videolar',
      'logout': 'Çıkış Yap',
      'personal_info': 'Kişisel Bilgiler',
      'general_settings': 'Genel Ayarlar',
      'select_language': 'Dil Seçin',
      'turkish': 'Türkçe',
      'english': 'İngilizce',
    },
    'en': {
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'language': 'App Language',
      'settings': 'Settings',
      'videos': 'Videos',
      'logout': 'Logout',
      'personal_info': 'Personal Info',
      'general_settings': 'General Settings',
      'select_language': 'Select Language',
      'turkish': 'Turkish',
      'english': 'English',
    },
  };
}
