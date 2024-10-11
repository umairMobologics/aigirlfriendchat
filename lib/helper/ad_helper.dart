import 'dart:io';

import 'package:agora_new_updated/provider/AdsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

//Real Ids
//Real Ids
//Real Ids
//Real Ids
//Real Ids

// class AdHelper {
//   static String get bannerAd {
//     return Platform.isAndroid
//         ? 'ca-app-pub-9800935656438737/5724347938'
//         : 'ca-app-pub-6680736034447013/8433231003';
//   }

//   static String get interstitialAd {
//     return Platform.isAndroid
//         ? 'ca-app-pub-9800935656438737/3956804846'
//         : 'ca-app-pub-6680736034447013/9359299865';
//   }

//   static String get nativeAd {
//     return Platform.isAndroid
//         ? 'ca-app-pub-9800935656438737/7806769762'
//         : 'ca-app-pub-6680736034447013/8241659312';
//   }

//   static String get openAppAd {
//     return Platform.isAndroid
//         ? 'ca-app-pub-9800935656438737/7591147348'
//         : 'ca-app-pub-6680736034447013/2793891510';
//   }
// }

//Test IDS
//Test IDS
//Test IDS
//Test IDS
//Test IDS
class AdHelper {
  static String get interstitialAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get nativeAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get openAppAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2867991109567972/2286806190';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/5662855259';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get bannerAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError("Unsupported platform");
  }
}

const int maxFailLoadAttempts = 3;

class InterstitialAdClass {
  static InterstitialAd? interstitialAd;
  static int _interstitialAdLoadAttempts = 0;
  static int count = 0;
  static int limit = 3;
  // static RxBool isInterAddLoaded = false.obs;

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          _interstitialAdLoadAttempts = 0;
          // log("interstitial ad is loaded , $count , $_interstitialAdLoadAttempts");
        },
        onAdFailedToLoad: (error) {
          _interstitialAdLoadAttempts += 1;
          interstitialAd = null;
          if (_interstitialAdLoadAttempts <= maxFailLoadAttempts) {
            // log("not loadedd, $_interstitialAdLoadAttempts");
            createInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd(BuildContext context) {
    if (interstitialAd != null) {
      context.read<Adsprovider>().interstitialAdShowing();
      InterstitialAdClass.count = 0;

      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        Future.delayed(const Duration(seconds: 1)).then((_) {
          InterstitialAdActive.isAdActiveNow = false;
          context.read<Adsprovider>().openInterstitialAdFalse();
        });
        InterstitialAdActive.isAdActiveNow = false;

        ad.dispose();
        createInterstitialAd();
      },

          // Update in the Code
          onAdShowedFullScreenContent: (ad) {
        // for checking InterstitialAd ads so that we can block app open add
        InterstitialAdActive.isAdActiveNow = true;
        context.read<Adsprovider>().interstitialAdShowing();
        // log("ad is showing ${isInterAddLoaded.value}");
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        context.read<Adsprovider>().openInterstitialAdFalse();
        ad.dispose();
        createInterstitialAd();
      });
      // log("show ad");
      interstitialAd!.show();
    }
  }
}

class InterstitialAdActive {
  static bool isAdActiveNow = false;
}
