import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/lang_controller.dart';
import '../controllers/auth_controller.dart';
import 'cards_credit _page.dart';
import 'new_product_page.dart';
import 'my_products_page.dart';
import 'profile_detail_page.dart';
import 'edit_profile_page.dart';
import 'orders_page.dart';

import 'saved_cards_page.dart';
import 'video_uploader_view.dart';
import 'language_settings_page.dart';
import '../utils/app_colors.dart';
import '../controllers/user_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        // profil dokümanı geldi mi?
        final prof = uc.profile.value;
        final isAdmin = (prof != null && prof['isAdmin'] == true);

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('Kişisel Bilgiler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            // --- SADECE ADMIN ---
            if (isAdmin) ...[
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Ürün Ekle'),
                subtitle: Text('Yeni Ürün Ekle'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Get.to(() => NewProductPage()),
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Ürünlerim'),
                subtitle: Text('Admin olarak eklediklerim'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Get.to(() => MyProductsPage()),
              ),
              Divider(height: 32),
            ],

            // --- herkes için ---
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Profil Bilgileri'),
              onTap: () => Get.to(() => ProfileDetailPage()),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Profil Düzenle'),
              onTap: () => Get.to(() => EditProfilePage()),
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Siparişlerim'),
              onTap: () => Get.to(() => OrdersPage()),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.add_card),
              title: Text('Kart Ekle'),
              onTap: () => Get.to(() => CardsCreditPage()),
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Kayıtlı Kartlarım'),
              onTap: () => Get.to(() => SavedCardsPage()),
            ),
            SizedBox(height: 24),
            VideoUploaderView(),
            SizedBox(height: 24),
            Obx(() {
              final lang = Get
                  .find<LangController>()
                  .locale
                  .value;
              return ListTile(
                leading: Icon(Icons.language),
                title: Text('Dil'),
                subtitle: Text(
                    lang.languageCode == 'tr' ? 'Türkçe' : 'English'),
              );
            }),
            SizedBox(height: 24),
            Text('Ayarlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ExpansionTile(
              leading: Icon(Icons.settings),
              title: Text('Genel Ayarlar'),
              children: [
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Dil Seçimi'),
                  onTap: () => Get.to(() => LanguageSettingsPage()),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Çıkış Yap'),
              onPressed: () async {
                await Get.find<AuthController>().signOut();
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      }),
    );
  }
}