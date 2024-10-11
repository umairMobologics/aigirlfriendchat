import 'package:agora_new_updated/screen/Onboarding/preference_screen.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MainOnBoarding extends StatefulWidget {
  const MainOnBoarding({super.key});

  @override
  State<MainOnBoarding> createState() => _MainOnBoardingState();
}

class _MainOnBoardingState extends State<MainOnBoarding> {
  final _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                OnBoardingCard(
                  currentPage: _currentPage,
                  pageController: _pageController,
                  image: 'assets/images/onBF.png',
                  text: 'Its easy to find a soul mate nearby & around you',
                ),
                OnBoardingCard(
                  currentPage: _currentPage,
                  pageController: _pageController,
                  image: 'assets/images/onBS.png',
                  text: 'Don\'t wait anymore find your soul mate right now!',
                ),
                OnBoardingCard(
                  currentPage: _currentPage,
                  pageController: _pageController,
                  image: 'assets/images/onBL.png',
                  text: 'Don\'t wait anymore find your soul mate right now!',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == 0 ? 50.0 : 12.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: _currentPage == 0 ? primaryColor : Colors.grey,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              const SizedBox(width: 8.0),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == 1 ? 50.0 : 12.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: _currentPage == 1 ? primaryColor : Colors.grey,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              const SizedBox(width: 8.0),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == 2 ? 50.0 : 12.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: _currentPage == 2 ? primaryColor : Colors.grey,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    _currentPage == 2
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const PreferenceScreen(),
                              transitionDuration: const Duration(seconds: 0),
                            ),
                            (route) => false,
                          )
                        : _pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                  },
                  child: Text(
                    _currentPage == 2 ? 'Start' : 'Next',
                    style: GoogleFonts.irishGrover(fontSize: 30),
                  )),
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}

class OnBoardingCard extends StatelessWidget {
  const OnBoardingCard(
      {super.key,
      required int currentPage,
      required PageController pageController,
      required this.image,
      required this.text});

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              image,
              height: 240.h,
              width: double.infinity,
            ),
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.irishGrover(
            color: whiteColor,
            fontSize: 28.sp,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
