import 'dart:developer';

import 'package:agora_new_updated/helper/AppOpenAdManager.dart';
import 'package:agora_new_updated/helper/ad_helper.dart';
import 'package:agora_new_updated/helper/app_lifecycle_reactor.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/aiGirlFriendChatList.dart';
import 'package:agora_new_updated/screen/ConnectNowScreen/connect_now_screen.dart';
import 'package:agora_new_updated/screen/Homepage/dashboardScreen.dart';
import 'package:agora_new_updated/screen/chatAI.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 2);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 2);

  int maxCount = 6;

  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
      _appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      _appLifecycleReactor.listenToAppStateChanges(context);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var gv = Get.put(Globlevariable()); // Initialize controller

    /// widget list
    final List<Widget> bottomBarPages = [
      ConnectNowScreen(
        singleCall: true,
      ),
      ConnectNowScreen(singleCall: false),
      const DashBoardScreen(),
      const AIGirlFriend(),
      const ChatAI()
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        _pageController.jumpToPage(2);
        _controller.jumpTo(2);
      },
      child: Scaffold(
        backgroundColor: white,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        // extendBody: true,
        // extendBodyBehindAppBar: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
                /// Provide NotchBottomBarController
                notchBottomBarController: _controller,

                color: mainClr,
                showLabel: true,
                textOverflow: TextOverflow.visible,
                maxLine: 1,
                shadowElevation: 5,
                kBottomRadius: 12.0,

                notchColor: mainClr,

                /// restart app if you change removeMargins
                removeMargins: false,
                bottomBarWidth: 500,
                showShadow: false,
                durationInMilliSeconds: 300,

                itemLabelStyle: const TextStyle(fontSize: 12, color: white),

                elevation: 1,
                bottomBarItems: const [
                  BottomBarItem(
                    inActiveItem: Center(
                        child: Center(
                            child: Icon(
                      Icons.video_call,
                      color: white,
                    ))),
                    activeItem: Center(
                        child: Icon(
                      Icons.video_call,
                      color: white,
                    )),
                    itemLabel: '1-1 Chat',
                  ),
                  BottomBarItem(
                    inActiveItem: Center(
                        child: Center(
                            child: Icon(
                      Icons.group_sharp,
                      color: white,
                    ))),
                    activeItem: Center(
                        child: Icon(
                      Icons.group_sharp,
                      color: white,
                    )),
                    itemLabel: 'GroupChat',
                  ),
                  BottomBarItem(
                    inActiveItem: Center(
                      child: Icon(
                        Icons.home,
                        color: white,
                      ),
                    ),
                    activeItem: Center(
                      child: Icon(
                        Icons.home,
                        color: white,
                      ),
                    ),
                    itemLabel: 'Home',
                  ),
                  BottomBarItem(
                    inActiveItem: Center(
                        child: Center(
                            child: Icon(
                      Icons.chat,
                      color: white,
                    ))),
                    activeItem: Center(
                        child: Icon(
                      Icons.chat,
                      color: white,
                    )),
                    itemLabel: 'AIGirlFriend',
                  ),
                  BottomBarItem(
                    inActiveItem: Center(
                        child: Center(
                            child: Icon(
                      Icons.chat,
                      color: white,
                    ))),
                    activeItem: Center(
                        child: Icon(
                      Icons.chat,
                      color: white,
                    )),
                    itemLabel: 'AI Chat',
                  ),
                ],
                onTap: (index) {
                  // InterstitialAdClass.count += 1;
                  // if (InterstitialAdClass.count ==
                  //         InterstitialAdClass.totalLimit &&
                  //     (!Subscriptioncontroller.isMonthlypurchased.value &&
                  //         !Subscriptioncontroller.isYearlypurchased.value)) {
                  //   InterstitialAdClass.showInterstitialAd(context);
                  // }
                  log('current selected index $index');

                  _pageController.jumpToPage(index);
                },

                kIconSize: 23.0,
              )
            : null,
      ),
    );
  }
}
