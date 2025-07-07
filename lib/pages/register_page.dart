// lib/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _authC = Get.find<AuthController>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  static const _buttonColor = Color(0xFF90CAF9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"), centerTitle: true),
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
            const SizedBox(height: 12),

            // Şifre onay alanı
            TextField(
              controller: _confirmPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

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
                onPressed: () async {
                  final email = _emailCtrl.text.trim();
                  final pass = _passwordCtrl.text;
                  final confirm = _confirmPassCtrl.text;

                  // Alan kontrolü
                  if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
                    Get.snackbar(
                      'Hata',
                      'Lütfen tüm alanları doldurun.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  if (pass != confirm) {
                    Get.snackbar(
                      'Hata',
                      'Şifreler eşleşmiyor.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  try {
                    // Kayıt
                    await _authC.register(email, pass);

                    // Başarılı olduğunda Login ekranına dön ve yeşil arka planlı bildirim ver
                    Get.offAll(() => LoginPage());
                    Get.snackbar(
                      'Başarılı',
                      'Kayıt başarılı! Lütfen giriş yapın.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } catch (e) {
                    // FirebaseAuthException da dahil tüm hatalar için
                    Get.snackbar(
                      'Kayıt Hatası',
                      e.toString(),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text(
                  'Register',
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
