import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_controller.dart';
import '../utils/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userC = Get.find<UserController>();
  final ImagePicker _picker = ImagePicker();

  File? _pickedImage;
  String? _currentPhotoUrl;

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController emailController;
  String selectedGender = 'Kadın';

  @override
  void initState() {
    super.initState();
    final profile = userC.profile.value ?? {};
    nameController = TextEditingController(text: profile['firstName'] ?? '');
    ageController = TextEditingController(text: (profile['age'] ?? '').toString());
    emailController = TextEditingController(text: profile['email'] ?? '');
    selectedGender = profile['gender'] ?? 'Kadın';
    _currentPhotoUrl = profile['photoUrl'] as String?;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        // Kullanıcı kodunuzda zaten galeriden seçip yükleme yapan metod var
        await userC.pickAndUploadPhoto();
        setState(() => _currentPhotoUrl = userC.photoUrl);
      }
    } catch (e) {
      Get.snackbar('Hata', 'Fotoğraf yüklenirken sorun oluştu');
    }
  }

  Future<void> _saveProfile() async {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text.trim());
    final email = emailController.text.trim();
    if (name.isEmpty || age == null || email.isEmpty) {
      Get.snackbar('Hata', 'Lütfen tüm alanları doğru doldurun');
      return;
    }
    await userC.updateProfile(
      firstName: name,
      age: age,
      gender: selectedGender,
      email: email,
      photoUrl: _currentPhotoUrl,
    );
    Get.back();
    Get.snackbar('Başarılı', 'Profil güncellendi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profili Düzenle')),
      backgroundColor: AppColors.scaffoldBg,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!) as ImageProvider
                        : (_currentPhotoUrl != null
                        ? NetworkImage(_currentPhotoUrl!)
                        : null),
                    child: (_pickedImage == null && _currentPhotoUrl == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    child: InkWell(
                      onTap: _pickAndUploadImage,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // İsim
            Card(
              color: AppColors.secondary,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                  hintText: 'İsim',
                ),
              ),
            ),

            // Yaş
            Card(
              color: AppColors.secondary,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.cake, color: AppColors.primary),
                  hintText: 'Yaş',
                ),
              ),
            ),

            // E-posta
            Card(
              color: AppColors.secondary,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.email, color: AppColors.primary),
                  hintText: 'E-posta',
                ),
              ),
            ),

            // Cinsiyet
            Card(
              color: AppColors.secondary,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.wc, color: AppColors.primary),
                  hintText: 'Cinsiyet',
                ),
                value: selectedGender,
                items: const [
                  DropdownMenuItem(value: 'Kadın', child: Text('Kadın')),
                  DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
                  DropdownMenuItem(value: 'Diğer', child: Text('Diğer')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => selectedGender = val);
                },
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.scaffoldBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
