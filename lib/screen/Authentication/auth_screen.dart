// ignore_for_file: use_build_context_synchronously

import 'package:agora_new_updated/helper/ad_helper.dart';
import 'package:agora_new_updated/provider/AdsProvider.dart';
import 'package:agora_new_updated/screen/Authentication/password_signin.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../provider/universal_provider.dart';
import '../../widgets/app_name.dart';
import '../../widgets/sign_in_button.dart';
import 'google_signin_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // static const platform = MethodChannel('samples.flutter.dev/battery');
  // late Future myFuture;
  NativeAd? nativead;
  bool isLoaded = false;

  loadNativeAd() {
    nativead = NativeAd(
        adUnitId: AdHelper.nativeAd,
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small),
        listener: NativeAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        }, onAdFailedToLoad: (ad, err) {
          nativead!.dispose();
        }),
        request: const AdRequest());

    nativead!.load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // loadNativeAd();

    // myFuture = _getOSVERSION();

    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
    super.initState();
  }

  // late double _version;

  // Future _getOSVERSION() async {
  //   try {
  //     final String result = await platform.invokeMethod('getOsVersion');
  //     setState(() {
  //       _version = double.parse(result);
  //     });
  //   } on PlatformException {
  //     debugPrint('something went wrong');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final universalProvider =
        Provider.of<UniversalProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColor,
      body:
          // FutureBuilder(
          //   future:  myFuture,
          //   builder: (context, snapshot) => snapshot.connectionState ==
          //           ConnectionState.waiting
          //       ? Scaffold(
          //           backgroundColor: backgroundColor,
          //           body: Center(
          //             child: LoadingAnimationWidget.prograssiveDots(
          //               size: 50.r,
          //               color: primaryColor,
          //             ),
          //           ),
          //         )
          //       :
          SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/main.png',
                      width: 100.w,
                      height: 100.h,
                    ),
                    const TextWidget(
                      text: 'Hum',
                      size: 50,
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                const TextWidget(
                  text: 'Let\'s you in',
                  size: 35,
                ),
                SizedBox(
                  height: 53.h,
                ),
                GestureDetector(
                  onTap: () async {
                    universalProvider.loadingLoginTotrue();
                    await Provider.of<GoogleSignInProvider>(context,
                            listen: false)
                        .googleLogin();
                    universalProvider.loadingLoginToFalse();
                    InterstitialAdClass.showInterstitialAd(context);
                  },
                  child: const AuthButtons(
                    buttonText: 'Continue With Google',
                    iconData: FontAwesomeIcons.google,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // _version >= 13
                //     ?
                // GestureDetector(
                //   onTap: () async {
                //     universalProvider.loadingLoginTotrue();
                //     await AppleSignIn().signInWithApple();
                //     universalProvider.loadingLoginToFalse();
                //     InterstitialAdClass.showInterstitialAd(context);
                //   },
                //   child: const AuthButtons(
                //     buttonText: 'Continue With Apple',
                //     iconData: FontAwesomeIcons.apple,
                //   ),
                // ),
                // // : const SizedBox(),
                // SizedBox(
                //   height: 29.h,
                // ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          color: const Color(0xff3F434E),
                          height: 3.h,
                        ),
                      ),
                      const Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          color: const Color(0xff3F434E),
                          height: 3.h,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 29.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) {
                          return const PasswordSignin(
                            isSignIn: true,
                          );
                        },
                      ),
                    );
                  },
                  child: const SignInButton(
                    btnText: 'Sign in with password',
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: whiteColor),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) {
                              return const PasswordSignin(
                                isSignIn: false,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                const Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Consumer<Adsprovider>(
                    builder: (_, value, child) =>
                        isLoaded && value.isOpenAdShowing == false
                            ? Container(
                                color: Colors.white,
                                height: 160,
                                child: AdWidget(ad: nativead!),
                              )
                            : const SizedBox(
                                height: 50,
                              ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
            Consumer<UniversalProvider>(
              builder: (context, value, child) => Align(
                  alignment: Alignment.center,
                  child: value.isLoadingLogin == true
                      ? const CircularProgressIndicator()
                      : const SizedBox()),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}

class AuthButtons extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  const AuthButtons({
    required this.buttonText,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 40.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: FaIcon(
                  iconData,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//  Navigator.push(
//                           context,
//                           CupertinoPageRoute(
//                             builder: (context) {
//                               return const SignUpORSignIn(
//                                 isSignIn: true,
//                               );
//                             },
//                           ),
//                         );

// Navigator.push(context,
//                                 CupertinoPageRoute(builder = (context) {
//                               return const SignUpORSignIn(
//                                 isSignIn: false,
//                               );
//                             }));
