import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/CustomButton.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/aiGirlFriendChatList.dart';
import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//girlFriend name Screen
class SetUpGirlFriendName extends StatefulWidget {
  final PageController pageController;
  final String girlFriendImage;
  const SetUpGirlFriendName(
      {super.key, required this.pageController, required this.girlFriendImage});

  @override
  State<SetUpGirlFriendName> createState() => _SetUpGirlFriendNameState();
}

class _SetUpGirlFriendNameState extends State<SetUpGirlFriendName> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Track the currently selected index (default is 0)
  int selectedIndex = 0;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: scaffoldBackground,
        body: Container(
          height: mq.height,
          width: mq.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              widget.girlFriendImage,
            ),
            fit: BoxFit.fill,
          )),
          child: Column(
            children: [
              // Cancel button and title
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(60),
                        onTap: () {
                          widget.pageController.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.linear,
                          );
                        },
                        child: Ink(
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.arrow_back,
                            color: white,
                            size: 30,
                          ),
                        ),
                      ),
                      const Text(
                        "Choose name & gender",
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
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
                            Icons.cancel_sharp,
                            color: white,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: mq.height * 0.15,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          TextField(
                            autofocus: true,
                            onSubmitted: (value) {
                              controller.text = value;

                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            onChanged: (value) {
                              controller.text = value;
                            },
                            cursorColor: white,
                            controller: controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: white),
                            decoration: const InputDecoration(
                                hintText: "Enter your Girlfriend name here...",
                                disabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(color: white54)),
                          ),
                          Selector<PageViewController, String>(
                            selector: (buildContext, p1) => p1.girlFriendGender,
                            builder: (context, value, child) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      context
                                          .read<PageViewController>()
                                          .setGirlFriendGender("Male");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: value == "Male"
                                              ? white
                                              : const Color.fromARGB(
                                                  255, 2, 36, 66),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: white, width: 0.7)),
                                      child: Text(
                                        "Male",
                                        style: TextStyle(
                                          color:
                                              value == "Male" ? black : white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      context
                                          .read<PageViewController>()
                                          .setGirlFriendGender("Female");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: value == "Female"
                                              ? white
                                              : const Color.fromARGB(
                                                  255, 2, 36, 66),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: white, width: 0.7)),
                                      child: Text(
                                        "Female",
                                        style: TextStyle(
                                          color:
                                              value == "Female" ? black : white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      context
                                          .read<PageViewController>()
                                          .setGirlFriendGender("Other");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: value == "Other"
                                              ? white
                                              : const Color.fromARGB(
                                                  255, 2, 36, 66),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: white, width: 0.7)),
                                      child: Text(
                                        "Other",
                                        style: TextStyle(
                                          color:
                                              value == "Other" ? black : white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (controller.text.isEmpty) {
                            showException("Please enter name first", context,
                                color: red);
                          } else {
                            // Add your action for the continue button

                            //save Username
                            context
                                .read<PageViewController>()
                                .setGirlFriendName(controller.text);
                            widget.pageController.animateToPage(6,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.linear);
                          }
                          // Add your action for the continue button
                          // context
                          //     .read<PageViewController>()
                          //     .setGirlFriendImage(images[selectedIndex]);
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Continue",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

//GirlFriend Age Screen
class GirlFriendAge extends StatefulWidget {
  final PageController pageController;
  const GirlFriendAge({super.key, required this.pageController});

  @override
  State<GirlFriendAge> createState() => _GirlFriendAgeState();
}

class _GirlFriendAgeState extends State<GirlFriendAge> {
  int selectedAge = 18; // Default selected age

  // List of ages from 17 to 100
  final List<int> ageList =
      List<int>.generate(100 - 18 + 1, (index) => 18 + index);

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var data = Provider.of<PageViewController>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBackground,
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            data.girlFriendImage,
          ),
          fit: BoxFit.fill,
        )),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        curve: Curves.linear,
                      );
                    },
                    child: Ink(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.arrow_back,
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
                          (Icons.cancel),
                          color: white,
                          size: 35,
                        )),
                  )
                ],
              ),
              //whats your name

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: mq.height * 0.1),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: grey.withOpacity(0.3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "${data.girlFriendName}'s Age?",
                          style: const TextStyle(color: white, fontSize: 30),
                        ),
                        SizedBox(height: mq.height * 0.01),
                        const Text(
                          textAlign: TextAlign.center,
                          "Choose age of your girlfriend",
                          style: TextStyle(color: white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mq.height * 0.03),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: mq.width * 0.8,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: grey.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        height: 200, // Adjust height as needed
                        child: CupertinoPicker(
                          itemExtent: 50, // Height of each item
                          scrollController: FixedExtentScrollController(
                              initialItem: selectedAge - 18),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedAge = ageList[index];
                            });
                            print("selected ager is now : $selectedAge");
                          },
                          children: ageList
                              .map((age) => Center(
                                      child: Text(
                                    "$age",
                                    style: const TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  )))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          // save Age
                          context
                              .read<PageViewController>()
                              .setGirlFriendAge(selectedAge);

                          widget.pageController.animateToPage(7,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.linear);

                          // Navigator.push(context,
                          // //     MaterialPageRoute(builder: (context) => const UserName()));
                        },
                        child: const CustomButton(
                          text: "Continue",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//GirlFriend personality Screen
class GirlFriendPersonality extends StatefulWidget {
  final PageController pageController;
  const GirlFriendPersonality({super.key, required this.pageController});

  @override
  State<GirlFriendPersonality> createState() => _GirlFriendPersonalityState();
}

class _GirlFriendPersonalityState extends State<GirlFriendPersonality> {
  List<String> personalityies = [
    "😜\nFlirty & Relaxed",
    "😏\nFlirty & Toxic",
    "😝\nFlirty & Funny",
    "😍\nRomantic & Positive",
    "😎\nDominant & Confident",
    "🤭\nShy & Supportive",
    "🧐\nFunny & Creative",
    "🤓\nFunny & Nerd",
  ];
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
                const Text(
                  "Choose Personality",
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
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
                        (Icons.cancel),
                        color: white,
                        size: 35,
                      )),
                )
              ],
            ),
            //whats your name

            const Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "Characteristics of your AI freind",
                  style: TextStyle(color: white54, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: mq.height * 0.02),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.3,
                      // mainAxisExtent: ,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      context
                          .read<PageViewController>()
                          .setGirlFriendPersonality(personalityies[index]);
                    },
                    child: Selector<PageViewController, String>(
                      selector: (buildContext, data) =>
                          data.girlFriendPersonality,
                      builder: (context, value, child) => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: value.contains(personalityies[index])
                                ? Border.all(color: white, width: 0.5)
                                : null,
                            color: grey.withOpacity(0.2)),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            personalityies[index],
                            style: const TextStyle(color: white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
              onTap: () async {
                if (value.girlFriendPersonality.isNotEmpty) {
                  //dave data
                  // Save the girlfriend data to the database
                  await value.saveGirlfriend();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const AIGirlFriend()),
                      (Route<dynamic> route) => false);
                } else {}
              },
              child: value.girlFriendPersonality.isNotEmpty
                  ? const CustomButton(
                      text: "Create your AI Friend",
                    )
                  : const CustomButton(
                      text: "Create your AI Friend",
                      color: white54,
                    )),
        ),
      )),
    );
  }
}
