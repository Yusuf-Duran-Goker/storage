
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/auth_controller.dart';
import 'register_page.dart';
import 'package:storage/pages/product_list_page.dart';
import 'package:storage/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final size          = MediaQuery.of(context).size;
    final authC         = Get.find<AuthController>();
    final emailCtrl     = TextEditingController();
    final passwordCtrl  = TextEditingController();
    const buttonColor   = Color(0xFF4682B4);

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

          // 2) Animasyon
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            height: size.height * 0.35,
            child: Lottie.asset('assets/anim/login_bg.json', fit: BoxFit.contain, repeat: true),
          ),

          // 3) Overlay
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
          Positioned(
            top: size.height * 0.48,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Başlık
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Fake ',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    TextSpan(
                      text: 'Storage',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ]),
                ),

                const SizedBox(height: 32),

                // Email
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),

                // Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      try {
                        await authC.login(emailCtrl.text.trim(), passwordCtrl.text);
                        Get.offAll(() => const ProductListPage());
                      } on FirebaseAuthException {
                        Get.snackbar('Giriş Hatası', 'Email veya şifre hatalı.', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.error.withOpacity(0.8), colorText: Colors.white);
                      }
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),

                // Register
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Get.to(() => const RegisterPage()),
                    child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
