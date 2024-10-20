import 'package:agora_new_updated/screen/ConnectNowScreen/bottomNavBar/bottomNavBAr.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/auth_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  late SharedPreferences prefs2;
  late int launchCountPrefs;
  late Future myFutureSharedPrefs;
  late Future blockedFuture;
  late bool isBlocked;

  Future<int> checkReportList(String uid) async {
    await prefs.setInt('launchCount', 0);
    final reportedNode = await FirebaseDatabase.instance
        .ref()
        .child(
          "reportedUser",
        )
        .child(uid)
        .once();

    final reportedUser = reportedNode.snapshot.value;

    if (reportedUser == null) {
      return 0;
    } else {
      prefs.setInt("reports", (reportedUser as Map)['count']);
      if ((reportedUser)['count'] >= 5) {
        await prefs2.setBool("isBanned", true);
      }
      return (reportedUser)['count'];
    }
  }

  @override
  void initState() {
    myFutureSharedPrefs = initSharedPrefs();
    blockedFuture = sharedPrefsBlocked();
    super.initState();
  }

  Future initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    launchCountPrefs = prefs.getInt("launchCount") ?? 0;

    await prefs.setInt('launchCount', launchCountPrefs + 1);
  }

  Future<bool> sharedPrefsBlocked() async {
    prefs2 = await SharedPreferences.getInstance();

    isBlocked = prefs2.getBool('isBanned') ?? false;
    return isBlocked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: FutureBuilder(
        future: blockedFuture,
        builder: (context, snapshot) => snapshot.data == true
            ? Scaffold(
                backgroundColor: backgroundColor,
                body: const Center(
                  child: Text(
                    'You have been blocked',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : FutureBuilder(
                future: myFutureSharedPrefs,
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Scaffold(
                      backgroundColor: white,
                      body: Center(
                        child: LoadingAnimationWidget.progressiveDots(
                          size: 50.r,
                          color: primaryColor,
                        ),
                      ),
                    );
                  } else if (futureSnapshot.hasError) {
                    return Scaffold(
                      backgroundColor: backgroundColor,
                      body: const Center(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(
                            backgroundColor: white,
                            body: Center(
                              child: LoadingAnimationWidget.progressiveDots(
                                size: 50.r,
                                color: primaryColor,
                              ),
                            ),
                          );
                        } else if (streamSnapshot.hasData) {
                          if (launchCountPrefs >= 25) {
                            return FutureBuilder(
                              future: checkReportList(streamSnapshot.data!.uid),
                              builder: (context, ss) {
                                if (ss.connectionState ==
                                    ConnectionState.waiting) {
                                  return Scaffold(
                                    backgroundColor: white,
                                    body: Center(
                                      child: LoadingAnimationWidget
                                          .progressiveDots(
                                        size: 50.r,
                                        color: primaryColor,
                                      ),
                                    ),
                                  );
                                } else if (ss.hasError) {
                                  return Scaffold(
                                    backgroundColor: backgroundColor,
                                    body: const Center(
                                      child: Text(
                                        'Something went wrong',
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (ss.data! >= 5) {
                                    return Scaffold(
                                      backgroundColor: backgroundColor,
                                      body: const Center(
                                        child: Text(
                                          'You have been blocked',
                                          style: TextStyle(color: white),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const BottomNavBarScreen();
                                  }
                                }
                              },
                            );
                          } else {
                            return const BottomNavBarScreen();
                          }
                        } else if (streamSnapshot.hasError) {
                          return Scaffold(
                            backgroundColor: backgroundColor,
                            body: const Center(
                              child: Text('Something went wrong'),
                            ),
                          );
                        } else {
                          return const AuthScreen();
                        }
                      },
                    );
                  }
                },
              ),
      ),
    );
  }
}
