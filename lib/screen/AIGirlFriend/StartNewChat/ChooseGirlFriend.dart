import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/CustomButton.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseGirlFriend extends StatefulWidget {
  final PageController pageController;
  const ChooseGirlFriend({super.key, required this.pageController});

  @override
  State<ChooseGirlFriend> createState() => _ChooseGirlFriendState();
}

class _ChooseGirlFriendState extends State<ChooseGirlFriend> {
  // List of image paths
  final List<String> images = [
    "assets/aiImages/jenny.png",
    "assets/aiImages/lee.png",
    "assets/aiImages/diana.png",
    "assets/aiImages/lisa.png",
    "assets/aiImages/alina.png",
    "assets/aiImages/lucy.png",
    "assets/aiImages/rubaka.png",
    "assets/aiImages/robert.png",
    "assets/aiImages/koju.png",
    "assets/aiImages/smith.png",
  ];

  final pageController = PageController(initialPage: 0);

  // ScrollController to control the animation of horizontal scroll
  final ScrollController _scrollController = ScrollController();

  // Track the currently selected index (default is 0)
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal, // or Axis.vertical
            itemCount: images.length, // Total number of items
            onPageChanged: (index) {
              setState(() {
                selectedIndex =
                    index; // Update selected index when page changes
                _animateToSelected(
                    index); // Animate row when a new avatar is selected
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                images[index], // Load the image from the list dynamically
                fit: BoxFit.fill, // Fit the image inside the page
              );
            },
          ),
          // Cancel button and title
          SafeArea(
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
                  "Choose your AI Friend",
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
          // Circular Avatars with animation
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    controller: _scrollController, // Attach scroll controller
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.linear);
                              selectedIndex =
                                  index; // Update selected avatar index
                              _animateToSelected(
                                  index); // Animate to selected avatar
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              maxRadius: 30,
                              backgroundImage: AssetImage(images[index]),
                              backgroundColor: selectedIndex == index
                                  ? Colors.blueAccent // Selected color
                                  : Colors.grey, // Unselected color
                              child: selectedIndex == index
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: mainClr, width: 2),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        // Add your action for the continue button
                        context
                            .read<PageViewController>()
                            .setGirlFriendImage(images[selectedIndex]);

                        widget.pageController.animateToPage(5,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.linear);
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
          ),
        ],
      ),
    );
  }

  // Function to animate scrolling based on the selected avatar index
  void _animateToSelected(int index) {
    // Define how many avatars you want to show at a time
    int avatarsVisibleAtOnce = 4;

    // Calculate the scroll position based on the avatar index
    double targetPosition = (index - avatarsVisibleAtOnce / 2) * 70;

    // Ensure the position is within bounds
    if (targetPosition < 0) {
      targetPosition = 0;
    }

    // Animate to the target position
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.linear,
    );
  }
}
