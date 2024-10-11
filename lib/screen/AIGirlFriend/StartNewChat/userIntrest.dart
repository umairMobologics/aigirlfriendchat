import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/CustomButton.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/IntrestWidget.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserIntrest extends StatefulWidget {
  final PageController pageController;
  const UserIntrest({super.key, required this.pageController});

  @override
  State<UserIntrest> createState() => _UserIntrestState();
}

class _UserIntrestState extends State<UserIntrest> {
  TextEditingController controller = TextEditingController();

  List<String> items = [
    "🎨 Art and Creativity",
    "📚 Literature",
    "🎬 Movies and TV Shows",
    "💃 Dancing",
    "☘️ Gardening",
    "🐈 Pets and Animals",
    "🖥️ Technology",
    "👗 Fashion",
    "✈️ Travel",
    "🎮 Gaming",
    "🏃‍♂️Fitness",
    "🏀 Sports",
  ];
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            //cancle button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    widget.pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear);
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      (Icons.arrow_back),
                      color: white,
                      size: 30,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      (Icons.cancel_sharp),
                      color: white,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
            //whats your name

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    textAlign: TextAlign.center,
                    "What's your intrests",
                    style: TextStyle(color: white, fontSize: 30),
                  ),
                  SizedBox(height: mq.height * 0.01),
                  const Text(
                    textAlign: TextAlign.center,
                    "Pick upto 5 intrests to enchnce your conversations",
                    style: TextStyle(color: white54, fontSize: 15),
                  ),
                  SizedBox(height: mq.height * 0.1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IntrestWidget(items: items[0]),
                      IntrestWidget(items: items[1]),
                    ],
                  ),
                  SizedBox(height: mq.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IntrestWidget(items: items[2]),
                      IntrestWidget(items: items[3]),
                    ],
                  ),
                  SizedBox(height: mq.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IntrestWidget(items: items[4]),
                      IntrestWidget(items: items[5]),
                    ],
                  ),
                  SizedBox(height: mq.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IntrestWidget(items: items[6]),
                      IntrestWidget(items: items[7]),
                      IntrestWidget(items: items[8]),
                    ],
                  ),
                  SizedBox(height: mq.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IntrestWidget(items: items[9]),
                      IntrestWidget(items: items[10]),
                      IntrestWidget(items: items[11]),
                    ],
                  ),
                  SizedBox(height: mq.height * 0.02),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<PageViewController>(
          builder: (context, value, child) => InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                value.intrests.isNotEmpty
                    ? widget.pageController.animateToPage(4,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear)
                    : null;
              },
              child: value.intrests.isNotEmpty
                  ? const CustomButton(
                      text: "Continue",
                    )
                  : const CustomButton(
                      text: "Continue",
                      color: white54,
                    )),
        ),
      )),
    );
  }
}
