// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:async';
import 'dart:developer';

import 'package:agora_new_updated/provider/AdsProvider.dart';
import 'package:agora_new_updated/screen/Onboarding/terms_and_condition.dart';
import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/ad_helper.dart';
import '../Authentication/google_signin_provider.dart';
import '../ConnectNowScreen/connect_now_screen.dart';
import 'home_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with WidgetsBindingObserver {
  late SharedPreferences prefs;
  bool isPressed = false;
  bool isPaused = false;

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<ConnectivityResult> connectivity = [];

  NativeAd? nativead;
  bool isLoaded = false;

  loadNativeAd() {
    nativead = NativeAd(
        adUnitId: AdHelper.nativeAd,
        // factoryId: 'listTile',
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
  void initState() {
    loadNativeAd();
    WidgetsBinding.instance.addObserver(this);

    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
    initPrefs();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      connectivity = result;
    });
    // ignore: avoid_print
    log('Connectivity changed: $connectivity');
  }

  @override
  void dispose() {
    nativead?.dispose();
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    log("current user is : ${user!.uid}");
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: const Text("Hum Live"),
          actions: [
            TextButton(
              onPressed: () async {
                if (user!.providerData.first.providerId == 'google.com') {
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .logout()
                      .then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const MyHomePage(),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                        (route) => false);
                  });
                } else if (user!.providerData.first.providerId == 'password') {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MyHomePage(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                      (route) => false);
                } else if (user!.providerData.first.providerId == 'apple.com') {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MyHomePage(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                      (route) => false);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                    color: mainClr, borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body:
            // Stack(
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Image.asset(
            //           'assets/images/onBL.png',
            //           width: 300.w,
            //           height: 300.h,
            //         ),
            //         const TextWidget(
            //           size: 20,
            //           text: 'Start Searching',
            //         ),
            //         SizedBox(
            //           height: 10.h,
            //         ),
            //         const TextWidget(
            //           size: 18,
            //           text: 'Don\'t wait, just click connect now',
            //         ),
            //         Expanded(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.end,
            //             children: [
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.width,
            //                 height: 40.h,
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(horizontal: 22.0),
            //                   child: isPressed == true
            //                       ? const SizedBox()
            //                       : ElevatedButton(
            //                           style: ElevatedButton.styleFrom(
            //                             shape: const StadiumBorder(),
            //                           ),
            //                           onPressed: () async {},
            //                           child: Text(
            //                             '1 to 1',
            //                             style: GoogleFonts.irishGrover(),
            //                           ),
            //                         ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 10.h,
            //               ),
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.width,
            //                 height: 40.h,
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(horizontal: 22.0),
            //                   child: isPressed == true
            //                       ? const SizedBox()
            //                       : ElevatedButton(
            //                           style: ElevatedButton.styleFrom(
            //                             shape: const StadiumBorder(),
            //                           ),
            //                           onPressed: () async {},
            //                           child: Text(
            //                             'Group Call',
            //                             style: GoogleFonts.irishGrover(),
            //                           ),
            //                         ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 10.h,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //                 child: Consumer<UniversalProvider>(
            //                   builder: (_, value, child) =>
            //                       _bannerAd != null && value.getOpenAppAd == false
            //                           ? SizedBox(
            //                               height: _bannerAd!.size.height.toDouble(),
            //                               child: AdWidget(ad: _bannerAd!),
            //                             )
            //                           : const SizedBox(
            //                               height: 140,
            //                             ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 10.h,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //     Align(
            //       alignment: Alignment.center,
            //       child: Consumer<UniversalProvider>(
            //         builder: (context, value, child) => value.isLoadingLogin == true
            //             ? const CircularProgressIndicator(
            //                 color: Colors.white,
            //               )
            //             : const SizedBox(),
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8, top: 10.h, bottom: 8),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (connectivity[0] != ConnectivityResult.none) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            ConnectNowScreen(singleCall: true),
                      ),
                    );
                  } else {
                    showToast("No Internet Connection!");
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 80.h,
                    color: primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        SizedBox(width: 40.w),
                        Text(
                          'Live Chat 1 to 1',
                          style: GoogleFonts.irishGrover(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/images/one.png',
                          width: 70.w,
                          height: 70.h,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (connectivity[0] != ConnectivityResult.none) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            ConnectNowScreen(singleCall: false),
                      ),
                    );
                  } else {
                    showToast("No Internet Connection!");
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 80.h,
                    color: primaryColor,
                    child: Row(
                      children: [
                        const Spacer(),
                        SizedBox(width: 40.w),
                        Text(
                          'Group Chat',
                          style: GoogleFonts.irishGrover(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          'assets/images/two.png',
                          width: 70.w,
                          height: 70.h,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const TermsAndConditions(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    alignment: Alignment.center,
                    height: 80.h,
                    width: double.infinity,
                    color: primaryColor,
                    child: Text(
                      'Terms & Conditions',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.irishGrover(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Consumer<Adsprovider>(
                  builder: (_, value, child) => isLoaded &&
                          !value.isOpenAdShowing &&
                          !value.isInterstitialAdShowing
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 120,
                            child: AdWidget(ad: nativead!),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ));
  }

//   Future createNodeForUserInDb() async {
//     Provider.of<UniversalProvider>(context, listen: false).loadingLoginTotrue();
//     String? deviceID = await PlatformDeviceId.getDeviceId;
//     //getting all created nodes from DB
//     final createdNodesFromDB = await FirebaseDatabase.instance
//         .ref()
//         .child("users")
//         .orderByChild("isWaiting") //deviceId
//         .equalTo(true) //deviceID
//         .once();

//     final createdNode = createdNodesFromDB.snapshot.value;
//     //if null, means no nodes in DB, so we will create new
//     if (createdNode == null) {
//       createNewNode(deviceID!);
//     } else {
//       final createdNodeAsMap = createdNode as Map;
//       final createdNodeAsList = [];
//       createdNodeAsMap.forEach(
//         (key, value) {
//           createdNodeAsList.add({"key": key, ...value});
//         },
//       );

//       int index = createdNodeAsList
//           .indexWhere((device) => device["deviceId"] == deviceID);

//       if (index != -1) {
//         String token =
//             await generateToken(createdNodeAsList[index]['channelName']);
//         isPressed = false;
//         Provider.of<UniversalProvider>(context, listen: false)
//             .loadingLoginToFalse();
//         Navigator.pushReplacement(
//           context,
//           CupertinoPageRoute(
//             builder: (context) {
//               return VideoScreen(
//                 isFirstTime: true,
//                 nodeKey: createdNodeAsList[index]['key'],
//                 nodeCreated: true,
//                 channelName: createdNodeAsList[index]['channelName'],
//                 token: token,
//               );
//             },
//           ),
//         );
//       } else {
//         String? savedListString = prefs.getString('myList');
//         List<dynamic> savedList = json.decode(savedListString ?? '[]');

//         final filteretedList = savedList.isEmpty
//             ? createdNodeAsList
//             : createdNodeAsList
//                 .where((e) => !savedList.contains(e['uId']))
//                 .toList();

//         if (filteretedList.isEmpty) {
//           createNewNode(deviceID!);
//           return;
//         }

//         await FirebaseDatabase.instance
//             .ref()
//             .child('users')
//             .child(filteretedList[0]['key'])
//             .update({
//           "remoteUID": user!.uid,
//           'connectedTo': user!.displayName ?? ""
//         });
//         String token = await generateToken(filteretedList[0]['channelName']);
//         isPressed = false;
//         Provider.of<UniversalProvider>(context, listen: false)
//             .loadingLoginToFalse();

//         Navigator.pushReplacement(
//           context,
//           CupertinoPageRoute(
//             builder: (context) {
//               return VideoScreen(
//                 isFirstTime: true,
//                 nodeKey: filteretedList[0]['key'],
//                 token: token,
//                 nodeCreated: false,
//                 channelName: filteretedList[0]['channelName'],
//                 localuID: filteretedList[0]['uId'],
//               );
//             },
//           ),
//         );
//       }
//     }
//   }

//   createNewNode(String deviceID) async {
//     final node = FirebaseDatabase.instance.ref().push().key;
//     final dbReference =
//         FirebaseDatabase.instance.ref().child("users").child(node!);
//     final channelName = getRandomString(15);
//     String token = await generateToken(channelName);

//     await dbReference.set({
//       'uId': user!.uid,
//       'deviceId': deviceID,
//       "channelName": channelName,
//       "isWaiting": true,
//       "name": user!.displayName ?? " ",
//       "token": token,
//     }).then((value) {
//       isPressed = false;

//       Provider.of<UniversalProvider>(context, listen: false)
//           .loadingLoginToFalse();
//       Navigator.pushReplacement(
//         context,
//         CupertinoPageRoute(
//           fullscreenDialog: true,
//           builder: (context) {
//             return VideoScreen(
//               isFirstTime: true,
//               nodeCreated: true,
//               channelName: channelName,
//               nodeKey: node,
//               token: token,
//             );
//           },
//         ),
//       );
//     });
//   }

//   Future<String> generateToken(String channelName) async {
//     var result =
//         await FirebaseFunctions.instance.httpsCallable("generateToken").call(
//       {
//         'channelName': channelName,
//       },
//     );
//     return result.data;
//   }

//   createNodeForMultipleUserInDb() async {
//     String? deviceID = await PlatformDeviceId.getDeviceId;
//     final createdNodesFromDB = await FirebaseDatabase.instance
//         .ref()
//         .child("multipleUsers")
//         .orderByChild("isWaiting")
//         .equalTo(true)
//         .once();

//     final createdNode = createdNodesFromDB.snapshot.value;
//     if (createdNode == null) {
//       createNewNodeForMultipleUsers(deviceID!);
//     } else {
//       final createdNodeAsMap = createdNode as Map;
//       final createdNodeAsList = [];

//       createdNodeAsMap.forEach((key, value) {
//         createdNodeAsList.add({"key": key, ...value});
//       });

//       String token = await generateToken(createdNodeAsList[0]['channelName']);
//       Navigator.pushReplacement(
//         context,
//         CupertinoPageRoute(
//           builder: (context) => MultipleUserVideo(
//               isFirstTime: true,
//               nodeKey: createdNodeAsList[0]['key'],
//               channelName: createdNodeAsList[0]['channelName'],
//               token: token),
//         ),
//       );
//     }
//   }

//   createNewNodeForMultipleUsers(String deviceId) async {
//     final node = FirebaseDatabase.instance.ref().push().key;
//     final dbReference =
//         FirebaseDatabase.instance.ref().child("multipleUsers").child(node!);
//     final channelName = getRandomString(15);
//     String token = await generateToken(channelName);

//     await dbReference.set(
//       {
//         "channelName": channelName,
//         "isWaiting": true,
//       },
//     ).then((value) {
//       Navigator.pushReplacement(
//         context,
//         CupertinoPageRoute(
//           builder: (context) => MultipleUserVideo(
//             isFirstTime: true,
//             nodeKey: node,
//             channelName: channelName,
//             token: token,
//           ),
//         ),
//       );
//     });
//   }
}
