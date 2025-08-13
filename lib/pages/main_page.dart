import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/pages/product_search_delegate.dart';

import '../controllers/user_controller.dart';
import 'new_product_page.dart';
import 'product_list_page.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final _pages = const [
    ProductListPage(),
    CartPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final uc = Get.find<UserController>();
    final user = uc.firebaseUser.value;
    final profile = uc.profile.value ?? {};
    final name = (profile['firstName'] as String?) ?? user?.email?.split('@').first ?? '';
    final photoUrl = (profile['photoUrl'] as String?) ?? user?.photoURL;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages.map((page) {
          if (page is ProductListPage) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, ${name.isNotEmpty ? name : 'there'}'),
                        Text("Let's go shopping", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(),
                    ),
                  ),
                ],
              ),
              body: page, // FloatingActionButton'ı buradan kaldırdık
            );
          }
          return page;
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}