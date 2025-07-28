// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'edit_profile_page.dart';
import '../utils/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userC = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.to(() => const EditProfilePage()),
          ),
        ],
      ),
      body: Obx(() {
        final data = userC.profile.value;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final name = data['firstName'] as String? ?? '';
        final email = data['email'] as String? ?? '';
        final age = data['age']?.toString() ?? '';
        final gender = data['gender'] as String? ?? '';
        final photoUrl = data['photoUrl'] as String?;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Profil Fotoğrafı'),
                          content: const Text('Profil fotoğrafını güncellemek ister misiniz?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hayır')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Evet')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        userC.pickAndUploadPhoto();
                      }
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                      backgroundColor: AppColors.primary.withOpacity(0.5),
                      child: photoUrl == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
                    ),
                  ),
                  Obx(() => userC.isUploadingPhoto.value
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink()),
                ],
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Profil Fotoğrafı'),
                      content: const Text('Profil fotoğrafını güncellemek ister misiniz?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hayır')),
                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Evet')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    userC.pickAndUploadPhoto();
                  }
                },
                child: const Text('Fotoğrafı Güncelle'),
              ),

              const SizedBox(height: 24),

              _readOnlyField(icon: Icons.person, label: 'Username', value: name),
              const SizedBox(height: 16),
              _readOnlyField(icon: Icons.email, label: 'Email', value: email),
              const SizedBox(height: 16),
              _readOnlyField(icon: Icons.cake, label: 'Age', value: age),
              const SizedBox(height: 16),
              _readOnlyField(icon: Icons.transgender, label: 'Gender', value: gender),
            ],
          ),
        );
      }),
    );
  }

  Widget _readOnlyField({required IconData icon, required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [Icon(icon, size: 20, color: Colors.grey.shade600), const SizedBox(width: 8), Text(value)],
          ),
        ),
      ],
    );
  }
}
