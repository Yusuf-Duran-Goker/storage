// lib/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/auth_controller.dart';
import 'login_page.dart';
import 'package:storage/utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size        = MediaQuery.of(context).size;
    final authC       = Get.find<AuthController>();
    final firstCtrl   = TextEditingController();
    final lastCtrl    = TextEditingController();
    final emailCtrl   = TextEditingController();
    final passCtrl    = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(fit: StackFit.expand, children: [
          // 1) Gradient arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),

          // 2) Animasyon: sayfanın en altında %30 yüksekliğinde
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.30,
            child: Lottie.asset(
              'assets/anim/register.json',
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),

          // 3) Hafif şeffaf overlay (isteğe bağlı)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.lightGradientTop, AppColors.lightGradientBottom],
              ),
            ),
          ),

          // 4) Form kartı
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
                  ],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  // Başlık: RichText ile LoginPage'deki renk paletini kullanıyoruz
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        // Eğer iki renkli bir başlık isterseniz şu satırı ekleyin:
                        // TextSpan(text: 'Page', style: TextStyle(/*...*/)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // First Name
                  TextField(
                    controller: firstCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.scaffoldBg,
                      hintText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextField(
                    controller: lastCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.scaffoldBg,
                      hintText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextField(
                    controller: emailCtrl,
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

                  // Password
                  TextField(
                    controller: passCtrl,
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

                  // Confirm Password
                  TextField(
                    controller: confirmCtrl,
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
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        final fn = firstCtrl.text.trim();
                        final ln = lastCtrl.text.trim();
                        final em = emailCtrl.text.trim();
                        final pw = passCtrl.text;
                        final cf = confirmCtrl.text;
                        if ([fn, ln, em, pw, cf].any((e) => e.isEmpty)) {
                          Get.snackbar(
                            'Hata',
                            'Lütfen tüm alanları doldurun.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.error.withOpacity(0.8),
                            colorText: AppColors.scaffoldBg,
                          );
                          return;
                        }
                        if (pw != cf) {
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
                          await authC.register(fn, ln, em, pw);
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
                        style: TextStyle(color: AppColors.scaffoldBg, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Login’e dön
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    onPressed: () => Get.offAll(() => const LoginPage()),
                    child: const Text('Already have an account? Login'),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
