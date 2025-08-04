// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/lang_controller.dart';
import '../controllers/auth_controller.dart';
import 'cards_credit _page.dart';
import 'video_uploader_view.dart';
import 'profile_detail_page.dart';
import 'edit_profile_page.dart';
import 'language_settings_page.dart';
import 'orders_page.dart';

import 'saved_cards_page.dart';  // ← Yeni eklenen import
import '../utils/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Kişisel Bilgiler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Profil'),
            subtitle: const Text('Profil bilgilerini görüntüle'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => const ProfileDetailPage()),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Profil Düzenle'),
            subtitle: const Text('Profil bilgilerini düzenle'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => const EditProfilePage()),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Siparişlerim'),
            subtitle: const Text('Geçmiş siparişlerinizi görüntüleyin'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => const OrdersPage()),
          ),
          const SizedBox(height: 8),
          // Yeni eklenen bölümler:
          ListTile(
            leading: const Icon(Icons.add_card),
            title: const Text('Kart Ekle'),
            subtitle: const Text('Yeni kart ekleyin'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => const CardsCreditPage()),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Kayıtlı Kartlarım'),
            subtitle: const Text('Eklediğiniz kartları görüntüleyin'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => const SavedCardsPage()),
          ),
          const SizedBox(height: 24),
          const VideoUploaderView(),
          const SizedBox(height: 24),
          Obx(() {
            final langC = Get.find<LangController>();
            final locale = langC.locale.value;
            return ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Dil'),
              subtitle: Text(locale.languageCode == 'tr' ? 'Türkçe' : 'English'),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'Ayarlar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('Genel Ayarlar'),
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Dil Seçimi'),
                onTap: () => Get.to(() => const LanguageSettingsPage()),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Çıkış Yap'),
            onPressed: () async {
              await Get.find<AuthController>().signOut();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
