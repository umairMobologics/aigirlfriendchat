import 'dart:developer';

import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/CustomButton.dart';
import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserName extends StatefulWidget {
  final PageController pageController;
  const UserName({super.key, required this.pageController});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            //cancle button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Ink(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        (Icons.cancel),
                        color: white,
                        size: 35,
                      )),
                )
              ],
            ),
            //whats your name

            Column(
              children: [
                SizedBox(height: mq.height * 0.1),
                const Text(
                  textAlign: TextAlign.center,
                  "What's your name?",
                  style: TextStyle(color: white, fontSize: 30),
                ),
                SizedBox(height: mq.height * 0.01),
                const Text(
                  textAlign: TextAlign.center,
                  "Introduce yourself to your freind",
                  style: TextStyle(color: white54, fontSize: 15),
                ),
                SizedBox(height: mq.height * 0.1),
                TextField(
                  autofocus: true,
                  onSubmitted: (value) {
                    controller.text = value;
                    log(controller.text);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (value) {
                    controller.text = value;
                    log(controller.text);
                  },
                  cursorColor: white,
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: white),
                  decoration: const InputDecoration(
                      hintText: "Enter your name here...",
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(color: white54)),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (controller.text.isEmpty) {
              showException("Please enter your name first", context,
                  color: red);
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
              //save Username
              context.read<PageViewController>().setUsername(controller.text);

              widget.pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear);
            }
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const UserName()));
          },
          child: const CustomButton(
            text: "Continue",
          ),
        ),
      ),
    );
  }
}
