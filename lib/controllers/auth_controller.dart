import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rxn<User> user = Rxn<User>();

   @override
  void onInit(){
     super.onInit();
     user.bindStream(_auth.authStateChanges());
   }
   /// Giriş yapma
    Future<void>login(String email, String password)async{
     await _auth.signInWithEmailAndPassword(
         email: email,
         password: password,
     );
    }

   /// Kayıt olma
   Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

   /// Oturumu kapatma
   Future<void> signOut() async {
    await _auth.signOut();
   }

  }

