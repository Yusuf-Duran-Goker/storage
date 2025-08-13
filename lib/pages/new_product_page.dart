import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  XFile? _imageFile;
  final _picker = ImagePicker();

  final List<String> _categories = const [
    'Kids',
    'Men',
    'Women',
    'Women\'s clothing',
    'Electronics',
    'Jewellery',
    'Mens clothing',
  ];

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = picked);
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Lütfen bir resim seçin')));
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final uc = Get.find<UserController>();
      final profile = uc.profile.value ?? {};
      final adminName = (profile['firstName'] as String?) ??
          user.email?.split('@').first ??
          'Admin';
      final adminEmail = user.email ?? 'admin@example.com';

      // --- STORAGE PATH: products/<uid>/<timestamp>.jpg  ---
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef =
      FirebaseStorage.instance.ref('products/${user.uid}/$fileName');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      // Upload
      final snapshot =
      await storageRef.putFile(File(_imageFile!.path), metadata);
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'title': _titleController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'imageUrl': imageUrl,
        'imagePath': 'products/${user.uid}/$fileName',
        'ownerId': user.uid,
        'adminName': adminName,
        'adminEmail': adminEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla eklendi')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      var errorMessage = 'Hata: $e';
      if (e is FirebaseException) {
        errorMessage += ' (Kod: ${e.code}, Mesaj: ${e.message})';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      // Teşhis için yol ve bucket’ı logla
      try {
        final user = FirebaseAuth.instance.currentUser!;
        final testRef =
        FirebaseStorage.instance.ref('products/${user.uid}/test');
        // ignore: avoid_print
        print('bucket: ${FirebaseStorage.instance.bucket}');
        // ignore: avoid_print
        print('fullPath: ${testRef.fullPath}');
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration:
                const InputDecoration(labelText: 'Fiyat', prefixText: '\$ '),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Zorunlu alan';
                  final price = double.tryParse(v);
                  if (price == null) return 'Geçerli bir sayı girin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? 'Bir kategori seçin' : null,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: Text('Resim seçin')),
                )
                    : Image.file(File(_imageFile!.path), height: 150),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _saveProduct, child: const Text('Kaydet')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
