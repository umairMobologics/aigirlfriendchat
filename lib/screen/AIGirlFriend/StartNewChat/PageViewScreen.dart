import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/StartNewChat/BirthdayScreen.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/StartNewChat/ChooseGirlFriend.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/StartNewChat/SetUpGirlfriend.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/StartNewChat/UserGender.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/StartNewChat/getName.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/StartNewChat/userIntrest.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pageviewscreen extends StatefulWidget {
  const Pageviewscreen({super.key});

  @override
  State<Pageviewscreen> createState() => _PageviewscreenState();
}

class _PageviewscreenState extends State<Pageviewscreen> {
  final pageController = PageController(
    initialPage: 0,

    // viewportFraction: 0.8,
  );
  @override
  Widget build(BuildContext context) {
    var pageViewcontroller = Provider.of<PageViewController>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBackground,
      body: PageView(
        // pageSnapping: false,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal, // or Axis.vertical
        children: [
          UserName(
            pageController: pageController,
          ),
          UserGender(
            pageController: pageController,
          ),
          UserBirthDay(
            pageController: pageController,
          ),
          UserIntrest(pageController: pageController),
          ChooseGirlFriend(
            pageController: pageController,
          ),
          SetUpGirlFriendName(
            pageController: pageController,
            girlFriendImage: pageViewcontroller.girlFriendImage,
          ),
          GirlFriendAge(
            pageController: pageController,
          ),
          GirlFriendPersonality(
            pageController: pageController,
          )
        ],
      ),
    );
  }
}
