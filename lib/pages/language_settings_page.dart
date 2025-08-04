import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lang_controller.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final langC = Get.find<LangController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dil Seçimi'),
      ),
      body: Obx(() {
        final currentLangCode = '${langC.locale.value.languageCode}_${langC.locale.value.countryCode}';

        return ListView(
          children: [
            RadioListTile<String>(
              title: const Text('Türkçe'),
              value: 'tr_TR',
              groupValue: currentLangCode,
              onChanged: (val) {
                if (val != null) {
                  print("Changing language to: $val");
                  langC.changeLocale(const Locale('tr', 'TR'));
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en_US',
              groupValue: currentLangCode,
              onChanged: (val) {
                if (val != null) {
                  langC.changeLocale(const Locale('en', 'US'));
                }
              },
            ),
          ],
        );
      }),
    );
  }
}
