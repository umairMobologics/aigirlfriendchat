import 'package:flutter/material.dart';

class UniversalProvider with ChangeNotifier {
  //For logging in when user click on login
  bool _isLoadingLogin = false; //For logging in when user click on login
  bool get isLoadingLogin =>
      _isLoadingLogin; //For logging in when user click on login

  bool isSignUpLoading = false;

  void isSignUpLoadingToTrue() {
    isSignUpLoading = true;
    notifyListeners();
  }

  void isSignUpLoadingToFalse() {
    isSignUpLoading = false;
    notifyListeners();
  }

  void loadingLoginTotrue() {
    //For logging in when user click on login
    _isLoadingLogin = true;
    notifyListeners();
  }

  void loadingLoginToFalse() {
    //For logging in when user click on login
    _isLoadingLogin = false;
    notifyListeners();
  }
}
