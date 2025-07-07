// lib/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/auth_controller.dart';
import 'login_page.dart';
import 'product_list_page.dart';
import 'package:storage/utils/app_colors.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size          = MediaQuery.of(context).size;
    final _authC        = Get.find<AuthController>();
    final _emailCtrl    = TextEditingController();
    final _passwordCtrl = TextEditingController();
    final _confirmCtrl  = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          fit: StackFit.expand,
          children: [

            // 1) Gradient arka plan
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2196F3), // AppColors.primary
                    Color(0xFF90CAF9), // AppColors.secondary
                  ],
                ),
              ),
            ),

            // 2) Animasyon (sayfanın en altında, %30 yüksekliğinde)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: size.height * 0.30,
                child: Lottie.asset(
                  'assets/anim/register.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),

            // 3) Ortadaki form kartı
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Başlık
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.scaffoldBg,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Şifre
                      TextField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.scaffoldBg,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Şifre Onay
                      TextField(
                        controller: _confirmCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.scaffoldBg,
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Register Butonu
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final email   = _emailCtrl.text.trim();
                            final pass    = _passwordCtrl.text;
                            final confirm = _confirmCtrl.text;

                            if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
                              Get.snackbar(
                                'Hata',
                                'Lütfen tüm alanları doldurun.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.error.withOpacity(0.8),
                                colorText: AppColors.scaffoldBg,
                              );
                              return;
                            }
                            if (pass != confirm) {
                              Get.snackbar(
                                'Hata',
                                'Şifreler eşleşmiyor.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.error.withOpacity(0.8),
                                colorText: AppColors.scaffoldBg,
                              );
                              return;
                            }

                            try {
                              await _authC.register(email, pass);
                              Get.offAll(() => const LoginPage());
                              Get.snackbar(
                                'Başarılı',
                                'Kayıt başarılı! Lütfen giriş yapın.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: AppColors.scaffoldBg,
                              );
                            } on FirebaseAuthException catch (e) {
                              Get.snackbar(
                                'Kayıt Hatası',
                                e.message ?? 'Bilinmeyen hata.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.error.withOpacity(0.8),
                                colorText: AppColors.scaffoldBg,
                              );
                            }
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: AppColors.scaffoldBg,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // "Zaten hesabım var" butonu
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () => Get.offAll(() => const LoginPage()),
                        child: const Text('Already have an account? Login'),
                      ),
                    ],
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
