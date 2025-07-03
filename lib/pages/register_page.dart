// lib/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/auth_controller.dart';


class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final AuthController authC = Get.find<AuthController>();

  final TextEditingController emailCtrl       = TextEditingController();
  final TextEditingController passwordCtrl    = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  final Color buttonColor = const Color(0xFF90CAF9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Password
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Confirm Password
            TextField(
              controller: confirmPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final email   = emailCtrl.text.trim();
                  final pass    = passwordCtrl.text;
                  final confirm = confirmPassCtrl.text;

                  // Basit validasyon
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
                    // Kayıt işlemi
                    await authC.register(email, pass);
                    // Kayıt sonrası otomatik çıkış yap
                    await authC.signOut();

                    Get.snackbar(
                      'Başarılı',
                      'Kayıt tamamlandı. Lütfen giriş yapın.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    // Login ekranına geri dön
                    Get.back();
                  } catch (e) {
                    Get.snackbar(
                      'Kayıt Hatası',
                      e.toString(),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
