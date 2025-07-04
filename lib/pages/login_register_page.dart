// lib/pages/login_register_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/auth_controller.dart';
import 'package:storage/pages/register_page.dart';     // ← package import!
import 'product_list_page.dart';

class LoginRegisterPage extends StatelessWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authC = Get.find<AuthController>();
    final _emailCtrl = TextEditingController();
    final _passwordCtrl = TextEditingController();
    const _buttonColor = Color(0xFF90CAF9);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fake Storage"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email alanı
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Şifre alanı
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Login Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  try {
                    await _authC.login(
                      _emailCtrl.text.trim(),
                      _passwordCtrl.text,
                    );
                    // Başarılıysa ürün listesine geç
                    Get.offAll(() => const ProductListPage());
                  } on FirebaseAuthException {
                    Get.snackbar(
                      'Giriş Hatası',
                      'Email veya şifreniz hatalı. Lütfen kontrol ediniz.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } catch (_) {
                    Get.snackbar(
                      'Hata',
                      'Beklenmeyen bir hata oluştu.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Register Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Get.to(() => RegisterPage()),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Log Out Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
