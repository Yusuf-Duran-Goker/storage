// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';    // Başlangıç ekranı olarak LoginPage
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase’i yalnızca bir kez initialize et (hot-restart duplicate-app önlemi)
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }

  // Controller’lar
  Get.put(ProductController(),  permanent: true);
  Get.put(AuthController(),     permanent: true);
  Get.put(CartController(),     permanent: true);
  Get.put(FavoriteController(), permanent: true);
  Get.put(UserController(),     permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fake Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),      // Uygulama LoginPage ile başlar
    );
  }
}
