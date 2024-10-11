import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'AppOpenAdManager.dart';

bool shouldShowOpenAd = true; // Flag to control ad display

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges(BuildContext context) {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state, context));
  }

  void _onAppStateChanged(AppState appState, BuildContext context) {
    if (appState == AppState.foreground) {
      if (shouldShowOpenAd
          // &&
          //     InterstitialAdClass.isInterAddLoaded.value == false &&
          //     (!Subscriptioncontroller.isMonthlypurchased.value &&
          //         !Subscriptioncontroller.isYearlypurchased.value)
          //
          ) {
        log("ad is going to be shown $shouldShowOpenAd");
        appOpenAdManager.showAdIfAvailable(context);
      }
    }
  }
}
