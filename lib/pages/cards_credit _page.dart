// lib/pages/cards_credit_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';

/// Otomatik "/" ekleyen formatlayıcı.
class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 2) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CardsCreditPage extends StatefulWidget {
  /// Düzenleme için gelen belge ID ve veriler
  final String? initialDocId;
  final Map<String, dynamic>? initialData;

  const CardsCreditPage({
    Key? key,
    this.initialDocId,
    this.initialData,
  }) : super(key: key);

  @override
  _CardsCreditPageState createState() => _CardsCreditPageState();
}

class _CardsCreditPageState extends State<CardsCreditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _isEditing = false;
  String? _editingDocId;

  @override
  void initState() {
    super.initState();
    // Eğer düzenleme modundaysa formu doldur
    if (widget.initialDocId != null && widget.initialData != null) {
      _isEditing = true;
      _editingDocId = widget.initialDocId;
      final data = widget.initialData!;
      _nameController.text = data['name'] ?? '';
      _numberController.text = data['masked']?.replaceAll('*', '') ?? '';
      _expiryController.text = data['expiry'] ?? '';
      _cvvController.text = data['cvv'] ?? '';
    }
    _nameController.addListener(_updateCard);
    _numberController.addListener(_updateCard);
    _expiryController.addListener(_updateCard);
    _cvvController.addListener(_updateCard);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _updateCard() => setState(() {});

  Future<void> _saveCard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen giriş yapın.')),
      );
      return;
    }
    final uid = user.uid;
    final name = _nameController.text.trim();
    final rawNumber = _numberController.text.trim();
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();
    // Harf ve boşluk kontrolü
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kart sahibinin adı sadece harf ve boşluk içermelidir.')),
      );
      return;
    }
    if (rawNumber.length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kart numarası en az 12 rakam olmalıdır.')),
      );
      return;
    }
    final last3 = rawNumber.substring(rawNumber.length - 3);
    final masked = List.filled(rawNumber.length - 3, '*').join() + last3;
    final coll = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards');
    try {
      if (_isEditing && _editingDocId != null) {
        await coll.doc(_editingDocId).update({
          'name': name,
          'last3': last3,
          'masked': masked,
          'expiry': expiry,
          'cvv': cvv,
        });
      } else {
        await coll.add({
          'name': name,
          'last3': last3,
          'masked': masked,
          'expiry': expiry,
          'cvv': cvv,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Kart güncellendi.' : 'Kart kaydedildi.')),
      );
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: \$e')),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _numberController.clear();
    _expiryController.clear();
    _cvvController.clear();
    setState(() {
      _isEditing = false;
      _editingDocId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Kart Güncelle' : 'Kart Ekle'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreditCardUi(
              cardHolderFullName: _nameController.text.isEmpty ? 'AD SOYAD' : _nameController.text,
              cardNumber: _numberController.text.isEmpty ? '0000000000000000' : _numberController.text,
              validThru: _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text,
              cvvNumber: _cvvController.text.isEmpty ? '000' : _cvvController.text,
              cardType: CardType.credit,
              creditCardType: CreditCardType.visa,
              showValidThru: true,
              doesSupportNfc: false,
              enableFlipping: true,
              width: double.infinity,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kart Numarası',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
              onChanged: (_) => _updateCard(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Kart Sahibinin Adı',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]'))],
              onChanged: (_) => _updateCard(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _expiryController,
              decoration: const InputDecoration(
                labelText: 'Son Kullanma Tarihi (MM/YY)',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), CardExpiryInputFormatter()],
              onChanged: (_) => _updateCard(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cvvController,
              decoration: const InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
              onChanged: (_) => _updateCard(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(_isEditing ? 'Güncelle' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}