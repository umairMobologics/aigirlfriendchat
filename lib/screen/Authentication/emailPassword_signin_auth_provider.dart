import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Email_SignIn_AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  String? _errorMessage;

  Email_SignIn_AuthProvider() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;
  String? get errorMessage => _errorMessage;

  // Sign in with email and password
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      _errorMessage = null;
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showToast(e.code);
      // _setError(_getFirebaseAuthErrorMessage(e.code));
      // _showErrorDialog(context, _getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      // _setError('An error occurred. Please try again.');
      // _showErrorDialog(context, 'An error occurred. Please try again.');
      showToast(e.toString());
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _setError('Failed to sign out.');
    }
  }

  // Handle authentication state changes
  void _onAuthStateChanged(User? firebaseUser) {
    _user = firebaseUser;
    notifyListeners();
  }

  // Handle error messages
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Helper function to map Firebase Auth errors
  String _getFirebaseAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
