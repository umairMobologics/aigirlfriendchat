import 'dart:developer';

import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/CustomButton.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBirthDay extends StatefulWidget {
  final PageController pageController;
  const UserBirthDay({super.key, required this.pageController});

  @override
  State<UserBirthDay> createState() => _UserBirthDayState();
}

class _UserBirthDayState extends State<UserBirthDay> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Open the date picker dialog automatically when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 200),
        () {
          _showDatePicker();
        },
      );
    });
  }

  // Function to show the BottomPicker for date selection
  void _showDatePicker() {
    BottomPicker.date(
      pickerTitle: const Text(
        'Set your Birthday',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: black,
        ),
      ),
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: DateTime(2000, 01, 01),
      maxDateTime: DateTime(2025),
      minDateTime: DateTime(1900),
      pickerTextStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      onChange: (index) {
        // Format the selected date without time
        String formattedDate =
            "${index.year}-${index.month.toString().padLeft(2, '0')}-${index.day.toString().padLeft(2, '0')}";
        log(formattedDate); // Prints the selected date in "YYYY-MM-DD" format

        context.read<PageViewController>().setUserDOB(formattedDate);
      },
      onSubmit: (index) {
        // Format the selected date without time
        String formattedDate =
            "${index.year}-${index.month.toString().padLeft(2, '0')}-${index.day.toString().padLeft(2, '0')}";
        log(formattedDate); // Prints the selected date in "YYYY-MM-DD" format
        context.read<PageViewController>().setUserDOB(formattedDate);
      },
      // bottomPickerTheme: BottomPickerTheme.temptingAzure,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Cancel button
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
            // What's your name text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: mq.height * 0.1),
                  const Text(
                    textAlign: TextAlign.center,
                    "Your date of birth?",
                    style: TextStyle(color: white, fontSize: 30),
                  ),
                  SizedBox(height: mq.height * 0.01),
                  const Text(
                    textAlign: TextAlign.center,
                    "Knowing your date of birth will give you surprises",
                    style: TextStyle(color: white54, fontSize: 15),
                  ),
                  SizedBox(height: mq.height * 0.1),
                ],
              ),
            ),
            // Select Date Button (optional)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _showDatePicker(); // Manually trigger the date picker
              },
              child: Container(
                  width: mq.width * 0.7,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border.all(color: mainClr),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            color: blue,
                          ),
                          SizedBox(
                            width: mq.width * 0.04,
                          ),
                          Consumer<PageViewController>(
                            builder: (context, value, child) => Text(
                              textAlign: TextAlign.center,
                              value.dob.isEmpty ? "Select Date" : value.dob,
                              style: const TextStyle(color: white),
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: white,
                      )
                    ],
                  )),
            ),

            // Consumer<PageViewController>(
            //   builder: (context, value, child) => Text(
            //     "DOB  is :  ${value.dob}",
            //     style:
            //         const TextStyle(color: white, fontWeight: FontWeight.bold),
            //   ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              widget.pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear);
            },
            child: const CustomButton(
              text: "Continue",
            ),
          ),
        ),
      ),
    );
  }
}
