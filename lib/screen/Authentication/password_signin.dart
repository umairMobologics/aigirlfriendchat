// ignore_for_file: constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:agora_new_updated/provider/AdsProvider.dart';
import 'package:agora_new_updated/screen/Authentication/auth_screen.dart';
import 'package:agora_new_updated/screen/Authentication/emailPassword_signin_auth_provider.dart';
import 'package:agora_new_updated/screen/Homepage/home_screen.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:agora_new_updated/widgets/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../helper/ad_helper.dart';
import '../../provider/universal_provider.dart';
import '../../utils/alert_dialogs.dart';
import '../../widgets/app_name.dart';

class PasswordSignin extends StatefulWidget {
  final bool isSignIn;
  const PasswordSignin({
    super.key,
    required this.isSignIn,
  });

  @override
  State<PasswordSignin> createState() => _PasswordSigninState();
}

class _PasswordSigninState extends State<PasswordSignin> {
  NativeAd? nativead;
  bool isLoaded = false;

  loadNativeAd() {
    nativead = NativeAd(
        adUnitId: AdHelper.nativeAd,
        factoryId: 'small',
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

  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordShowing = true;

  static const String EMAIL_ALREADY_USED = 'ERROR_EMAIL_ALREADY_IN_USE';
  static const String EMAIL_ALREADY_USED2 =
      'account-exists-with-different-credential';
  static const String EMAIL_ALREADY_USED3 = 'email-already-in-use';
  static const String WRONG_PASSWORD = 'ERROR_WRONG_PASSWORD';
  static const String WRONG_PASSWORD_2 = 'wrong-password';
  static const String USER_NOT_FOUND = 'ERROR_USER_NOT_FOUND';
  static const String USER_NOT_FOUND_2 = 'user-not-found';
  static const String INVALID_EMAIL = 'invalid-email';
  static const String INVALID_EMAIL_2 = 'ERROR_INVALID_EMAIL';
  late StreamSubscription<bool> keyboardSubscription;
  bool isKeyBoardOpen = false;

  @override
  void initState() {
    // loadNativeAd();
    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }

    // Keyboard visibility listener
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          isKeyBoardOpen = visible;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the subscription to prevent calling setState on a disposed widget
    keyboardSubscription.cancel();
    nativead?.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final universalProvider =
        Provider.of<UniversalProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          onPressed: () {
            FocusManager.instance.primaryFocus!.unfocus();
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return const AuthScreen();
                    }),
                (route) => false);
          },
        ),
        title: Text(widget.isSignIn ? 'Sign in' : 'Sign up'),
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Flexible(
            child: SafeArea(
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: TextWidget(
                              text: widget.isSignIn
                                  ? 'Log in to your account'
                                  : 'Create Your Account',
                              size: 35,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0.w, right: 10.w),
                                        child: const FaIcon(
                                          FontAwesomeIcons.solidMessage,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: secondaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                      labelText: 'Email',
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    focusNode: _emailFocusNode,
                                    controller: _emailController,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode);
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(
                                              r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    controller: _passwordController,
                                    obscureText: isPasswordShowing,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0.w, right: 10.w),
                                        child: const FaIcon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isPasswordShowing =
                                                !isPasswordShowing;
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(right: 8.0.w),
                                          child: FaIcon(
                                            isPasswordShowing
                                                ? FontAwesomeIcons.eyeSlash
                                                : FontAwesomeIcons.eye,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: secondaryColor,
                                          width: 2.0,
                                        ),
                                      ),
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    focusNode: _passwordFocusNode,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Consumer<Email_SignIn_AuthProvider>(
                            builder: (context, authProvider, child) {
                              return Column(children: [
                                if (authProvider.errorMessage != null)
                                  Text(
                                    authProvider.errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                              ]);
                            },
                          ),
                          GestureDetector(
                            onTap: () async {
                              final navigator = Navigator.of(context);
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                FocusManager.instance.primaryFocus!.unfocus();

                                try {
                                  universalProvider.loadingLoginTotrue();
                                  if (widget.isSignIn) {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    )
                                        .then((onValue) {
                                      log("singin user message :  $onValue");
                                    });
                                  } else {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    )
                                        .then((onValue) {
                                      log("sign up status : $onValue");
                                    });
                                  }
                                  InterstitialAdClass.showInterstitialAd(
                                      context);

                                  showToast(widget.isSignIn
                                      ? 'Login Successfully'
                                      : 'Account Create Successfully');
                                  _emailController.clear();
                                  _passwordController.clear();
                                  universalProvider.loadingLoginToFalse();
                                  navigator.pushAndRemoveUntil(
                                      CupertinoPageRoute(
                                    builder: (context) {
                                      return const MyHomePage();
                                    },
                                  ), (route) => false);
                                } on FirebaseAuthException catch (e) {
                                  universalProvider.loadingLoginToFalse();
                                  log("eoor while signin ${e.code}");
                                  if (e.code == EMAIL_ALREADY_USED ||
                                      e.code == EMAIL_ALREADY_USED2 ||
                                      e.code == EMAIL_ALREADY_USED3) {
                                    showException(
                                        'Email already used by other user,',
                                        context);
                                  } else if (e.code == WRONG_PASSWORD ||
                                      e.code == WRONG_PASSWORD_2) {
                                    showException(
                                        'Wrong email/password combination',
                                        context);
                                  } else if (e.code == USER_NOT_FOUND ||
                                      e.code == USER_NOT_FOUND_2) {
                                    showException(
                                        'No user found with this email.',
                                        context);
                                  } else if (e.code == INVALID_EMAIL ||
                                      e.code == INVALID_EMAIL_2) {
                                    showException(
                                        'Email address is invalid.', context);
                                  } else {
                                    showException(
                                        'Login failed. Please try again.',
                                        context);
                                  }
                                } catch (e) {
                                  universalProvider.loadingLoginToFalse();

                                  showException(
                                      'Something went wrong, try again',
                                      context);
                                }
                              }
                            },
                            child: SignInButton(
                              btnText:
                                  widget.isSignIn ? 'Log in' : 'Create Account',
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          widget.isSignIn
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const PasswordSignin(
                                                    isSignIn: true),
                                            transitionDuration:
                                                const Duration(seconds: 0),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'sign in',
                                        style: TextStyle(
                                          color: primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Consumer<UniversalProvider>(
                          builder: (context, value, child) => Align(
                              alignment: Alignment.center,
                              child: value.isLoadingLogin == true
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: white,
                                    ))
                                  : const SizedBox()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<Adsprovider>(
              builder: (_, value, child) => isLoaded &&
                      value.isOpenAdShowing == false &&
                      value.isInterstitialAdShowing == false
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
          )
        ],
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final IconData icon;
  const AuthButton({
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.h,
      height: 50.h,
      margin: const EdgeInsets.only(left: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
        ),
        onPressed: () {},
        child: FaIcon(icon),
      ),
    );
  }
}
