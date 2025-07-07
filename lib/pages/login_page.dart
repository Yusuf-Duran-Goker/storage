// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import '../controllers/auth_controller.dart';
import 'register_page.dart';
import 'product_list_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size          = MediaQuery.of(context).size;
    final _authC        = Get.find<AuthController>();
    final _emailCtrl    = TextEditingController();
    final _passwordCtrl = TextEditingController();
    const accentColor   = Color(0xFFFF9800);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          fit: StackFit.expand,
          children: [

            // 1) Başlığın tam üstüne gelecek şekilde animasyonu hizala:
            Align(
              alignment: const Alignment(0, -2),
              child: SizedBox(
                height: size.height * 0.75,
                width: size.width * 1.2,
                child: Lottie.asset(
                  'assets/anim/login_bg.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),

            // 2) Altına gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x332196F3),
                    Color(0x3390CAF9),
                  ],
                ),
              ),
            ),

            // 3) Form kartı
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
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
                      const Text(
                        'Fake Storage',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
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
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login Butonu
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                              Get.offAll(() => const ProductListPage());
                            } on FirebaseAuthException {
                              Get.snackbar(
                                'Giriş Hatası',
                                'Email veya şifreniz hatalı. Lütfen kontrol edin.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                Colors.redAccent.withOpacity(0.8),
                                colorText: Colors.white,
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Register Butonu
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: accentColor),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Get.to(() => RegisterPage()),
                          child: const Text(
                            'Register',
                            style:
                            TextStyle(color: accentColor, fontSize: 16),
                          ),
                        ),
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
