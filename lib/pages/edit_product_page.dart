// lib/pages/edit_product_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> initialData;

  const EditProductPage({
    Key? key,
    required this.productId,
    required this.initialData,
  }) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;
  XFile? _imageFile;
  String? _currentImageUrl;
  final _picker = ImagePicker();
  final List<String> _categories = [
    'Kids', 'Men', 'Women', 'Women\'s clothing',
    'Electronics', 'Jewellery', 'Mens clothing',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _titleController = TextEditingController(text: data['title']);
    _priceController = TextEditingController(text: data['price'].toString());
    _descriptionController = TextEditingController(text: data['description']);
    _selectedCategory = data['category'];
    _currentImageUrl = data['imageUrl'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = picked);
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final user = FirebaseAuth.instance.currentUser!;
      String imageUrl = _currentImageUrl!;

      if (_imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = FirebaseStorage.instance
            .ref()
            .child('products')
            .child(user.uid)
            .child(fileName);
        await ref.putFile(File(_imageFile!.path));
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('products')
          .doc(widget.productId)
          .update({
        'title': _titleController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla güncellendi')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: \$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Başlık
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 12),
              // Fiyat
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Fiyat', prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Zorunlu alan';
                  if (double.tryParse(v) == null) return 'Geçerli sayı girin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Açıklama
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 12),
              // Kategori
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
              // Resim
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? (_currentImageUrl != null
                    ? Image.network(_currentImageUrl!, height: 150)
                    : Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: Text('Resim seçin')),
                ))
                    : Image.file(File(_imageFile!.path), height: 150),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
