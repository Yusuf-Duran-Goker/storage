import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/user_controller.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userC = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Detayları'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        final profile = userC.profile.value;

        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // 👤 PROFİL FOTOĞRAFI
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: userC.photoUrl != null
                    ? NetworkImage(userC.photoUrl!)
                    : null,
                backgroundColor: Colors.grey[300],
                child: userC.photoUrl == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // ℹ️ PROFİL BİLGİLERİ
            _buildInfoCard(Icons.person, 'İsim', profile['firstName'] ?? 'Yok'),
            _buildInfoCard(Icons.email, 'Email', profile['email'] ?? 'Yok'),
            _buildInfoCard(Icons.cake, 'Yaş', profile['age']?.toString() ?? 'Yok'),
            _buildInfoCard(Icons.wc, 'Cinsiyet', profile['gender'] ?? 'Yok'),
          ],
        );
      }),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
