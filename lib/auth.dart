import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanges => _auth.authStateChanges();

  bool isUserLoggedIn = false;

  get getAuthCurrentUserUID {
    String uid = "";
    if (_auth != null) {
      if (_auth.currentUser != null) {
        uid = _auth.currentUser.uid;
      }
    }
    return uid;
  }

  get getUserLoginStatus {
    if (_auth != null) {
      if (_auth.currentUser != null) {
        isUserLoggedIn = true;
      }
    }
    return isUserLoggedIn;
  }

  set setUserLoginStatus(bool status) {
    isUserLoggedIn = status;
    notifyListeners();
  }
}
