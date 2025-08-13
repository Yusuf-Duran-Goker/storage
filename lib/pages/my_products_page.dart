import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_product_page.dart';

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({Key? key}) : super(key: key);

  Future<bool> _isAdmin(String uid) async {
    final snap =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return (snap.data()?['isAdmin'] == true);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Ürünlerim')),
      body: FutureBuilder<bool>(
        future: _isAdmin(uid),
        builder: (context, adminSnap) {
          if (adminSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final isAdmin = adminSnap.data == true;

          Query query = FirebaseFirestore.instance
              .collection('products')
              .orderBy('createdAt', descending: true);

          // Admin: tüm ürünler; Normal kullanıcı: sadece kendi ürünleri
          if (!isAdmin) {
            query = query.where('ownerId', isEqualTo: uid);
          }

          return StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Henüz ürün eklemediniz.'));
              }

              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data()! as Map<String, dynamic>;
                  final docId = docs[index].id;

                  final imageUrl =
                  (data['imageUrl'] ?? data['image'] ?? '') as String;
                  final title = (data['title'] ?? '') as String;
                  final price = data['price'];
                  final priceText = () {
                    if (price == null) return '';
                    if (price is num) return price.toStringAsFixed(2);
                    return price.toString();
                  }();

                  final canEdit = isAdmin; // sadece admin düzenleyip silebilsin

                  return Card(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: (imageUrl.isNotEmpty)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(Icons.image_not_supported),
                      title: Text(title),
                      subtitle: priceText.isEmpty
                          ? null
                          : Text('\$ $priceText'),
                      trailing: canEdit
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditProductPage(
                                    productId: docId,
                                    initialData: data,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Onay'),
                                  content: const Text(
                                      'Ürünü silmek istediğinize emin misiniz?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Hayır'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Evet'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(docId)
                                    .delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Ürün silindi')),
                                );
                              }
                            },
                          ),
                        ],
                      )
                          : null,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
