import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:role_base_auth/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // function to Sing Up
  Future<String?> singup({
    required String name,
    required String? role,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      // add data in firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {'name': name.trim(), 'email': email.trim(), 'role': role},
      );
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  // Function to Login

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      // add data in firestore
      DocumentSnapshot docSnp =await _firestore.collection("Users").doc(userCredential.user!.uid).get();
      return docSnp['role'];

    } catch (e) {
      return e.toString();
    }
    return null;
  }
}
