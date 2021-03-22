import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanges => _auth.authStateChanges();
}
