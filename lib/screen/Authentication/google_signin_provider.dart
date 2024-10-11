import 'dart:developer';

import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  GoogleSignInAccount? _user;

  GoogleSignInAccount get googleUser => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        log("user null");
        return;
      }
      _user = googleUser;
      log("$_user");
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((onValue) {
        log("message : $onValue");
      });
    } catch (e) {
      log("googgle sogn in error $e");
      showToast('Something went wrong');
    }
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
