import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/CustomButton.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserGender extends StatefulWidget {
  final PageController pageController;
  const UserGender({super.key, required this.pageController});

  @override
  State<UserGender> createState() => _UserGenderState();
}

class _UserGenderState extends State<UserGender> {
  TextEditingController controller = TextEditingController();
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
                  SizedBox(height: mq.height * 0.1),
                  const Text(
                    textAlign: TextAlign.center,
                    "What's your gender?",
                    style: TextStyle(color: white, fontSize: 30),
                  ),
                  SizedBox(height: mq.height * 0.01),
                  const Text(
                    textAlign: TextAlign.center,
                    "Which pronoun would you like your freind to call you",
                    style: TextStyle(color: white54, fontSize: 15),
                  ),
                  SizedBox(height: mq.height * 0.1),
                ],
              ),
            ),
            // Consumer<PageViewController>(
            //   builder: (context, value, child) {
            //     return Text(
            //       "name is :  ${value.userName}",
            //       style: const TextStyle(color: white),
            //     );
            //   },
            // ),

            Consumer<PageViewController>(
              builder: (context, value, child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GenderWidget(
                      gender: "Male",
                      value: value,
                    ),
                    GenderWidget(
                      gender: "Female",
                      value: value,
                    ),
                    GenderWidget(
                      gender: "Other",
                      value: value,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            widget.pageController.animateToPage(2,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear);
          },
          child: const CustomButton(
            text: "Continue",
          ),
        ),
      )),
    );
  }
}

class GenderWidget extends StatelessWidget {
  final String gender;
  final dynamic value;
  const GenderWidget({
    super.key,
    required this.gender,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.read<PageViewController>().setUserGender(gender);
        },
        child: Ink(
          // color: Colors.blue, // color of grid items

          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: value.userGender == gender
                  ? white
                  : const Color.fromARGB(255, 2, 36, 66),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: white54, width: 0.3)),
          child: Text(
            gender,
            style: TextStyle(
                fontSize: 16.0,
                color: value.userGender == gender ? black : white,
                fontWeight: FontWeight.bold),
          ),
        ));
  }
}
