// lib/service/onboarding_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Firestore’dan kontrol ederek kullanıcının onboarding’i tamamlayıp tamamlamadığını döner
  Future<bool> hasSeenOnboarding() async {
    final user = _auth.currentUser;
    if (user == null) return true;
    final doc = await _db.collection('users').doc(user.uid).get();
    final data = doc.data();
    return data?['onboardingDone'] == true;
  }

  /// Firestore’da kullanıcı dokümanına onboardingDone=true yazar
  Future<void> markOnboardingSeen() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).set(
      {'onboardingDone': true},
      SetOptions(merge: true),
    );
  }

  /// Yaş, cinsiyet ve ilgi alanlarını Firestore’a kaydeder
  Future<void> saveOnboardingData({
    required int age,
    required String gender,
    required List<String> interests,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final docRef = _db.collection('users').doc(user.uid);
    await docRef.set({
      'age': age,
      'gender': gender,
      'interests': interests,
    }, SetOptions(merge: true));
  }
}
