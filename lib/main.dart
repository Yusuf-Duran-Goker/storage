// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:storage/controllers/bottom_nav_controller.dar.dart';
import 'firebase_options.dart';

import 'utils/app_colors.dart';
import 'pages/login_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/lang_controller.dart';
 // ← Yeni eklenen kontrolcü importu

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  // Controller'lar
  Get.put(ProductController(),  permanent: true);
  Get.put(AuthController(),     permanent: true);
  Get.put(CartController(),     permanent: true);
  Get.put(FavoriteController(), permanent: true);
  Get.put(UserController(),     permanent: true);
  Get.put(LangController(),     permanent: true);
  Get.put(BottomNavController(), permanent: true); // ← Yeni eklenen kontrolcü kaydı

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langC = Get.find<LangController>();
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fake Store',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.scaffoldBg,
          // ... diğer tema ayarları aynı ...
        ),
        locale: langC.locale.value,
        translations: langC,
        fallbackLocale: const Locale('tr', 'TR'),
        home: const LoginPage(),
      );
    });
  }
}
