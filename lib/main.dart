// ignore_for_file: unused_local_variable

import 'dart:ui';

import 'package:agora_new_updated/Database/HiveDatabase/HiveBox.dart';
import 'package:agora_new_updated/firebase_options.dart';
import 'package:agora_new_updated/models/MessageModel.dart';
import 'package:agora_new_updated/provider/AdsProvider.dart';
import 'package:agora_new_updated/provider/universal_provider.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Controller/CharScreenController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/aiGirlFriendChatList.dart';
import 'package:agora_new_updated/screen/Authentication/apple_sign_in.dart';
import 'package:agora_new_updated/screen/Authentication/emailPassword_signin_auth_provider.dart';
import 'package:agora_new_updated/screen/Authentication/google_signin_provider.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();

  //init hive
  await Hive.initFlutter();
  Hive.registerAdapter(SaveMessagesModelAdapter());
  Hive.registerAdapter(ConversationAdapter());

  await HiveBox.initHive();

  //analytics
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // set observer
  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  //crashlytics
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => GoogleSignInProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => UniversalProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => AppleSignIn()),
        ),
        ChangeNotifierProvider(create: (_) => Email_SignIn_AuthProvider()),
        ChangeNotifierProvider(create: ((context) => Adsprovider())),
        ChangeNotifierProvider(create: ((context) => ChatProvider())),

        // Provide the ChatProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agora video calling',
        theme: ThemeData(
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: secondaryColor,
          ),
          primarySwatch: primaryColorTheme,
        ),
        home: const AIGirlFriend(),
      ),
    );
  }
}
