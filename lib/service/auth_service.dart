import 'package:firebase_auth/firebase_auth.dart';


class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Register
    Future<void> createUser({
    required String email,
    required String password,

   })async{
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    //Login
  Future<void> singIn({
    required String email,
    required String password
  })async{
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
  }
  //Singout
Future<void> singOut()async{
      await _firebaseAuth.signOut();
}

  }