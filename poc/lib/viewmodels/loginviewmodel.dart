import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();

  bool isProcessing = false;

  // Future<FirebaseApp> _initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();

  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => Dashboard(user: user),
  //       ),
  //     );
  //   }
  //   return firebaseApp;
  // }


  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
    return user;
  }

}