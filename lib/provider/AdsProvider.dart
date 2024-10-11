import 'package:flutter/material.dart';

class Adsprovider extends ChangeNotifier {
//openApp ad variables
  bool _isShowingOpenAppAd = false;

  bool get isOpenAdShowing {
    return _isShowingOpenAppAd;
  }

  openAppAdShowing() {
    _isShowingOpenAppAd = true;
    notifyListeners();
  }

  openAppAdFalse() {
    _isShowingOpenAppAd = false;
    notifyListeners();
  }

//interstital addd cariables
  bool _isShowingInterstitialAd = false;

  bool get isInterstitialAdShowing {
    return _isShowingInterstitialAd;
  }

  interstitialAdShowing() {
    _isShowingInterstitialAd = true;
    notifyListeners();
  }

  openInterstitialAdFalse() {
    _isShowingInterstitialAd = false;
    notifyListeners();
  }
}
