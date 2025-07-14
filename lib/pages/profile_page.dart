// lib/pages/profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() {
              final path = pc.imagePath.value;           // ← burayı imageUrl → imagePath yaptık
              return CircleAvatar(
                radius: 60,
                backgroundImage:
                path != null
                    ? FileImage(File(path))
                    : null,
                child: path == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF90CAF9),
              ),
              onPressed: () => pc.pickImage(),
              child: const Text('Avatarı Seç',
                  style: TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}
