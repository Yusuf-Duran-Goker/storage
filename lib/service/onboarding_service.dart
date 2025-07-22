// lib/service/onboarding_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingService {
  String _seenKey(String uid) => 'seen_onboarding_$uid';

  /// Daha önce bu kullanıcı için onboarding gösterildi mi?
  Future<bool> hasSeenOnboarding() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return true;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey(uid)) ?? false;
  }

  /// Bu kullanıcı için onboarding görüldü olarak işaretle
  Future<void> markOnboardingSeen() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey(uid), true);
  }

  /// Yaş ve cinsiyeti Firestore’a kaydet
  Future<void> saveAgeAndGender(int age, String gender) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'age': age,
      'gender': gender,
    }, SetOptions(merge: true));
  }

  /// Onboarding boyunca seçilen verileri Firestore’a kaydet
  Future<void> saveOnboardingData({
    required int age,
    required String gender,
    required List<String> interests,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'age': age,
      'gender': gender,
      'interests': interests,
    }, SetOptions(merge: true));
  }
}
