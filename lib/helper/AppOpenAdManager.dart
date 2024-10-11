import 'dart:developer';

import 'package:agora_new_updated/helper/ad_helper.dart';
import 'package:agora_new_updated/provider/AdsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  // static RxBool isOpenAdLoaded = false.obs;

  static bool isLoaded = false;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: AdHelper.openAppAd,
      // orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isLoaded = true;
          log("openapp ad is loaded");
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable(BuildContext context) {
    if (!isAdAvailable) {
      loadAd();
      return;
    }

    InterstitialAdClass.count = 0;
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        context.read<Adsprovider>().openAppAdShowing();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        context.read<Adsprovider>().openAppAdFalse();
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        // Provider.of<WidgetProvider>(context, listen: false)
        //     .toggleOpenAppAdToFalse();
        context.read<Adsprovider>().openAppAdFalse();
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
