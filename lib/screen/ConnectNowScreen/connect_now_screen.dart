// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_new_updated/provider/universal_provider.dart';
import 'package:agora_new_updated/screen/1-1Chat/video_screen.dart';
import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:agora_new_updated/utils/getDeviceID.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/ad_helper.dart';
import '../../utils/random_string.dart';
import '../../widgets/app_name.dart';
import '../GroupChat/multiple_screen.dart';

class ConnectNowScreen extends StatefulWidget {
  bool singleCall;
  ConnectNowScreen({
    super.key,
    required this.singleCall,
  });

  @override
  State<ConnectNowScreen> createState() => _ConnectNowScreenState();
}

class _ConnectNowScreenState extends State<ConnectNowScreen>
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    nativead?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // loadNativeAd();
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

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<UniversalProvider>(context, listen: false)
            .loadingLoginToFalse();
        return true;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Provider.of<UniversalProvider>(context, listen: false)
                  .loadingLoginToFalse();
              Navigator.pop(context);
            },
          ),
          title: Text(widget.singleCall ? "1-1 Chat" : "Group Chat"),
          actions: const [
            // TextButton(
            //   onPressed: () async {
            //     if (user!.providerData.first.providerId == 'google.com') {
            //       Provider.of<GoogleSignInProvider>(context, listen: false)
            //           .logout()
            //           .then((value) {
            //         Navigator.pushAndRemoveUntil(
            //             context,
            //             PageRouteBuilder(
            //               pageBuilder:
            //                   (context, animation, secondaryAnimation) =>
            //                       const MyHomePage(),
            //               transitionDuration: const Duration(seconds: 0),
            //             ),
            //             (route) => false);
            //       });
            //     } else if (user!.providerData.first.providerId == 'password') {
            //       await FirebaseAuth.instance.signOut();

            //       Navigator.pushAndRemoveUntil(
            //           context,
            //           PageRouteBuilder(
            //             pageBuilder: (context, animation, secondaryAnimation) =>
            //                 const MyHomePage(),
            //             transitionDuration: const Duration(seconds: 0),
            //           ),
            //           (route) => false);
            //     } else if (user!.providerData.first.providerId == 'apple.com') {
            //       await FirebaseAuth.instance.signOut();

            //       Navigator.pushAndRemoveUntil(
            //           context,
            //           PageRouteBuilder(
            //             pageBuilder: (context, animation, secondaryAnimation) =>
            //                 const MyHomePage(),
            //             transitionDuration: const Duration(seconds: 0),
            //           ),
            //           (route) => false);
            //     }
            //   },
            //   child: const Text(
            //     'Logout',
            //     style: TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // )
          ],
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/onBL.png',
                  width: 300.w,
                  height: 300.h,
                ),
                const TextWidget(
                  size: 20,
                  text: 'Start Searching',
                  color: black,
                ),
                SizedBox(
                  height: 10.h,
                ),
                const TextWidget(
                  size: 18,
                  text: 'Don\'t wait, just click connect now',
                  color: black,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.singleCall == true
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 40.h,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0),
                                child: isPressed == true
                                    ? const SizedBox()
                                    : InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          if (connectivity[0] !=
                                              ConnectivityResult.none) {
                                            createNodeForUserInDb();
                                          } else {
                                            showToast(
                                                "No Internet Connection!");
                                          }
                                        },
                                        child: Ink(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: mainClr,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'connect now',
                                            style: GoogleFonts.irishGrover(
                                                color: white, fontSize: 18),
                                          ),
                                        ),
                                      ),
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 10.h,
                      ),
                      widget.singleCall == false
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 40.h,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0),
                                child: isPressed == true
                                    ? const SizedBox()
                                    : InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          if (connectivity[0] !=
                                              ConnectivityResult.none) {
                                            createNodeForMultipleUserInDb();
                                          } else {
                                            showToast(
                                                "No Internet Connection!");
                                          }
                                        },
                                        child: Ink(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: mainClr,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'connect now',
                                            style: GoogleFonts.irishGrover(
                                                color: white, fontSize: 18),
                                          ),
                                        ),
                                      ),
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 10.h,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      //   child: Consumer<UniversalProvider>(
                      //     builder: (_, value, child) => isLoaded &&
                      //             value.getOpenAppAd == false
                      //         ? Container(
                      //             decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.circular(5)),
                      //             height: 160,
                      //             child: AdWidget(ad: nativead!),
                      //           )
                      //         : const SizedBox(
                      //             height: 160,
                      //           ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Consumer<UniversalProvider>(
                builder: (context, value, child) => value.isLoadingLogin == true
                    ? const CircularProgressIndicator(
                        color: mainClr,
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future createNodeForUserInDb() async {
    Provider.of<UniversalProvider>(context, listen: false).loadingLoginTotrue();
    String? deviceID = await PlatformDeviceId.getDeviceId();
    //getting all created nodes from DB
    final createdNodesFromDB = await FirebaseDatabase.instance
        .ref()
        .child("users")
        .orderByChild("isWaiting") //deviceId
        .equalTo(true) //deviceID
        .once();

    final createdNode = createdNodesFromDB.snapshot.value;
    //if null, means no nodes in DB, so we will create new
    if (createdNode == null) {
      createNewNode(deviceID);
    } else {
      final createdNodeAsMap = createdNode as Map;
      final createdNodeAsList = [];
      createdNodeAsMap.forEach(
        (key, value) async {
          if (value.containsKey('channelName') == false) {
            await FirebaseDatabase.instance
                .ref()
                .child("users")
                .child(key)
                .remove();
          } else {
            createdNodeAsList.add({"key": key, ...value});
          }
        },
      );
      if (createdNodeAsList.isEmpty) {
        await createNewNode(deviceID);
        return;
      }

      int index = createdNodeAsList
          .indexWhere((device) => device["deviceId"] == deviceID);

      if (index != -1) {
        String token =
            await generateToken(createdNodeAsList[index]['channelName']);
        log("token is ***** $token");
        isPressed = false;
        Provider.of<UniversalProvider>(context, listen: false)
            .loadingLoginToFalse();
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) {
              return VideoScreen(
                isFirstTime: true,
                nodeKey: createdNodeAsList[index]['key'],
                nodeCreated: true,
                channelName: createdNodeAsList[index]['channelName'],
                token: token,
              );
            },
          ),
        );
      } else {
        String? savedListString = prefs.getString('myList');
        List<dynamic> savedList = json.decode(savedListString ?? '[]');

        final filteretedList = savedList.isEmpty
            ? createdNodeAsList
            : createdNodeAsList
                .where((e) => !savedList.contains(e['uId']))
                .toList();

        if (filteretedList.isEmpty) {
          createNewNode(deviceID);
          return;
        }

        await FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(filteretedList[0]['key'])
            .update({
          "remoteUID": user!.uid,
          'connectedTo': user!.displayName ?? ""
        });
        String token = await generateToken(filteretedList[0]['channelName']);
        log("token is ***** $token");
        isPressed = false;
        Provider.of<UniversalProvider>(context, listen: false)
            .loadingLoginToFalse();

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) {
              return VideoScreen(
                isFirstTime: true,
                nodeKey: filteretedList[0]['key'],
                token: token,
                nodeCreated: false,
                channelName: filteretedList[0]['channelName'],
                localuID: filteretedList[0]['uId'],
              );
            },
          ),
        );
      }
    }
  }

  createNewNode(String deviceID) async {
    final node = FirebaseDatabase.instance.ref().push().key;
    final dbReference =
        FirebaseDatabase.instance.ref().child("users").child(node!);
    final channelName = getRandomString(15);
    String token = await generateToken(channelName);
    log("token is ***** $token");

    await dbReference.set({
      'uId': user!.uid,
      'deviceId': deviceID,
      "channelName": channelName,
      "isWaiting": true,
      "name": user!.displayName ?? " ",
      "token": token,
    }).then((value) {
      isPressed = false;

      Provider.of<UniversalProvider>(context, listen: false)
          .loadingLoginToFalse();
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) {
            return VideoScreen(
              isFirstTime: true,
              nodeCreated: true,
              channelName: channelName,
              nodeKey: node,
              token: token,
            );
          },
        ),
      );
    });
  }

  Future<String> generateToken(String channelName) async {
    var result =
        await FirebaseFunctions.instance.httpsCallable("generateToken").call(
      {
        'channelName': channelName,
      },
    );
    return result.data;
  }

  createNodeForMultipleUserInDb() async {
    Provider.of<UniversalProvider>(context, listen: false).loadingLoginTotrue();
    String? deviceID = await PlatformDeviceId.getDeviceId();
    final createdNodesFromDB = await FirebaseDatabase.instance
        .ref()
        .child("multipleUsers")
        .orderByChild("isWaiting")
        .equalTo(true)
        .once();

    final createdNode = createdNodesFromDB.snapshot.value;
    if (createdNode == null) {
      createNewNodeForMultipleUsers(deviceID);
    } else {
      final createdNodeAsMap = createdNode as Map;
      final createdNodeAsList = [];

      createdNodeAsMap.forEach((key, value) {
        createdNodeAsList.add({"key": key, ...value});
      });

      String token = await generateToken(createdNodeAsList[0]['channelName']);
      log("token is ***** $token");
      Provider.of<UniversalProvider>(context, listen: false)
          .loadingLoginToFalse();
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => MultipleUserVideo(
              isFirstTime: true,
              nodeKey: createdNodeAsList[0]['key'],
              channelName: createdNodeAsList[0]['channelName'],
              token: token),
        ),
      );
    }
  }

  createNewNodeForMultipleUsers(String deviceId) async {
    final node = FirebaseDatabase.instance.ref().push().key;
    final dbReference =
        FirebaseDatabase.instance.ref().child("multipleUsers").child(node!);
    final channelName = getRandomString(15);
    String token = await generateToken(channelName);
    log("token is ***** $token");

    await dbReference.set(
      {
        "channelName": channelName,
        "isWaiting": true,
      },
    ).then((value) {
      Provider.of<UniversalProvider>(context, listen: false)
          .loadingLoginToFalse();
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => MultipleUserVideo(
            isFirstTime: true,
            nodeKey: node,
            channelName: channelName,
            token: token,
          ),
        ),
      );
    });
  }
}
