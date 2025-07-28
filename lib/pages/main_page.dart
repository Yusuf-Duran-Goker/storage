// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/pages/product_search_delegate.dart';

import '../controllers/user_controller.dart';
import 'product_list_page.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 4 sayfamız var. Her biri kendi AppBar'ını içeriyor.
  final _pages = const [
    ProductListPage(),
    CartPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Kullanıcı adı + fotoğrafı için:
    final uc        = Get.find<UserController>();
    final profile   = uc.profile.value ?? {};
    final firstName = profile['firstName'] as String?;
    final email     = uc.firebaseUser.value?.email;
    final name      = firstName ?? (email != null ? email.split('@').first : '');
    final photoUrl  = profile['photoUrl'] as String?;

    return Scaffold(
      // body: IndexedStack ile, sayfalar yeniden oluşturulmadan arasında geçiş yapıyoruz
      body: IndexedStack(
        index: _currentIndex,
        children: _pages.map((page) {
          // Eğer ana sayfaysa AppBar'a özel başlığı + avatar ekleyelim
          if (page is ProductListPage) {
            return Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? const Icon(Icons.person_outline)
                        : null,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi, ${name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : ''}'),
                    const Text(
                      "Let's go shopping",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: ProductSearchDelegate(),
                      );
                    },
                  ),
                ],
              ),
              body: page,
            );
          }
          // Diğer sayfalar zaten kendi Scaffold + AppBar içeriyor:
          return page;
        }).toList(),
      ),

      // Alt gezinme çubuğu
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
