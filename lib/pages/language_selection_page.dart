import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage/controllers/lang_controller.dart';


class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final langC = Get.find<LangController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('select_language'.tr),
      ),
      body: Obx(() {
        return ListView(
          children: [
            RadioListTile<Locale>(
              title: const Text('Türkçe'),
              value: const Locale('tr', 'TR'),
              groupValue: langC.locale.value,
              onChanged: (val) {
                if (val != null) langC.changeLocale(val);
              },
            ),
            RadioListTile<Locale>(
              title: const Text('English'),
              value: const Locale('en', 'US'),
              groupValue: langC.locale.value,
              onChanged: (val) {
                if (val != null) langC.changeLocale(val);
              },
            ),
          ],
        );
      }),
    );
  }
}
