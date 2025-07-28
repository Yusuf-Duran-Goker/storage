// lib/pages/edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/user_controller.dart';
import '../utils/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userC = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _ageCtrl;
  String _gender = '';

  @override
  void initState() {
    super.initState();
    final data = userC.profile.value ?? {};
    _nameCtrl = TextEditingController(text: data['firstName'] as String? ?? '');
    _ageCtrl = TextEditingController(text: (data['age']?.toString() ?? ''));
    _gender = data['gender'] as String? ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => userC.pickAndUploadPhoto(),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: userC.profile.value?['photoUrl'] != null
                      ? NetworkImage(userC.profile.value!['photoUrl'])
                      : null,
                  backgroundColor: AppColors.primary.withOpacity(0.5),
                  child: userC.profile.value?['photoUrl'] == null
                      ? const Icon(Icons.camera_alt,
                      size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageCtrl,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid age'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender.isEmpty ? null : _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Erkek', 'Kadın', 'Diğer']
                    .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v!),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await userC.updateProfile(
                      firstName: _nameCtrl.text.trim(),
                      age: int.parse(_ageCtrl.text.trim()),
                      gender: _gender,
                    );
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
