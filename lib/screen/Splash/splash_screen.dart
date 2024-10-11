import 'package:agora_new_updated/screen/Homepage/home_screen.dart';
import 'package:agora_new_updated/screen/OnBoarding/main_on_boarding.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:agora_new_updated/widgets/app_name.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/agora_credientials.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;
  late bool isFirstTime;
  @override
  void initState() {
    goToNextScreen();
    super.initState();
  }

  goToNextScreen() async {
    try {
      final admin = FirebaseDatabase.instance.ref().child('AdminFlutter');
      AgoraCredientials.appCertificate =
          (await admin.child('agoraCert').once()).snapshot.value as String;
      AgoraCredientials.appId =
          ((await admin.child('agoraID').once()).snapshot.value) as String;

      prefs = await SharedPreferences.getInstance();
      isFirstTime = prefs.getBool('isFirstTime') ?? true;
      await prefs.setBool('isFirstTime', false);
      Future.delayed(const Duration(seconds: 4)).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  isFirstTime ? const MainOnBoarding() : const MyHomePage(),
              transitionDuration: const Duration(seconds: 0),
            ),
            (route) => false);
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: const Text('Something went wrong,'),
                actions: [
                  CupertinoButton(
                      child: const Text('Try Again'),
                      onPressed: () {
                        Navigator.pop(context);
                        goToNextScreen();
                      })
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/main.png',
                      width: 100.w,
                      height: 100.h,
                    ),
                    const TextWidget(size: 50, text: 'Hum')
                  ],
                ),
              ),
            ),
            LoadingAnimationWidget.hexagonDots(color: primaryColor, size: 70.r),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
