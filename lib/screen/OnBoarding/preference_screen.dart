import 'package:agora_new_updated/screen/Homepage/home_screen.dart';
import 'package:agora_new_updated/screen/Onboarding/terms_and_condition.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:agora_new_updated/widgets/app_name.dart';
import 'package:country_list_picker/country_list_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Gender {
  male,
  female,
  random,
}

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  Gender gender = Gender.male;
  RangeValues _ageRange = const RangeValues(18, 60);
  String country = 'United States Of America';
  Countries initialCountry = Countries.United_States;
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/main.png',
                        width: 100.w,
                        height: 100.h,
                      ),
                      const TextWidget(
                        text: 'Hum',
                        size: 50,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8),
                    child: TextWidget(
                      text: 'I am interested in: ',
                      size: 35,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        width: 70.h,
                        height: 3.h,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Gender:',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: primaryColor,
                              ),
                              backgroundColor:
                                  gender.name.toLowerCase() == 'male'
                                      ? primaryColor
                                      : secondaryColor,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              setState(() {
                                gender = Gender.male;
                              });
                            },
                            child: Text(
                              'Male',
                              style: TextStyle(
                                color: gender.name.toLowerCase() == 'male'
                                    ? white
                                    : black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: primaryColor,
                              ),
                              backgroundColor:
                                  gender.name.toLowerCase() == 'female'
                                      ? primaryColor
                                      : secondaryColor,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              setState(() {
                                gender = Gender.female;
                              });
                            },
                            child: Text(
                              'Female',
                              style: TextStyle(
                                color: gender.name.toLowerCase() == 'female'
                                    ? white
                                    : black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: primaryColor,
                              ),
                              backgroundColor:
                                  gender.name.toLowerCase() == 'random'
                                      ? primaryColor
                                      : secondaryColor,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              setState(() {
                                gender = Gender.random;
                              });
                            },
                            child: Text(
                              'Random',
                              style: TextStyle(
                                color: gender.name.toLowerCase() == 'random'
                                    ? white
                                    : black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Age: ',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: _ageRange,
                        onChanged: (values) {
                          setState(() {
                            _ageRange = values;
                          });
                        },
                        min: 18,
                        divisions: 68,
                        max: 80,
                        labels: RangeLabels(
                            _ageRange.start.truncate().toString(),
                            _ageRange.end.truncate().toString()),
                      ),
                      // RangeSlider(
                      //   labels: RangeLabels(
                      //     _ageRange.start.round().toString(),
                      //     _ageRange.end.round().toString(),
                      //   ),
                      //   min: 1,
                      //   max: 80,
                      //   inactiveColor: Colors.grey,
                      //   divisions: 62,
                      //   values: _ageRange,
                      //   onChanged: (values) {
                      //     setState(() {
                      //       _ageRange = RangeValues(values.end, values.start);
                      //     });
                      //   },
                      // ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              country,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: CountryListPicker(
                              iconDown: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 24,
                                color: white,
                              ),
                              initialCountry: initialCountry,
                              border: InputBorder.none,
                              isShowCountryName: false,
                              isShowInputField: false,
                              isShowDiallingCode: false,
                              onCountryChanged: ((value) {
                                country = value.name.official.toString();
                                setState(() {});
                              }),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Checkbox(
                                      side: const BorderSide(
                                          color: Color(0xffffffff)),
                                      activeColor: primaryColor,
                                      value: isCheck,
                                      onChanged: (_) {
                                        setState(() {
                                          isCheck = _!;
                                        });
                                      }),
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  const TermsAndConditions()));
                                    },
                                    child: RichText(
                                      text: const TextSpan(
                                        text: "I have read the",
                                        children: [
                                          TextSpan(
                                            text: " Terms and conditions ",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          TextSpan(text: " and agreed to it. "),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                          color: primaryColor,
                                        ),
                                        backgroundColor: secondaryColor,
                                      ),
                                      onPressed: () {
                                        _ageRange = const RangeValues(18, 60);
                                        gender = Gender.male;
                                        isCheck = false;

                                        setState(() {});
                                      },
                                      child: Text(
                                        'Reset',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(),
                                      onPressed: isCheck == false
                                          ? null
                                          : () {
                                              Navigator.pushAndRemoveUntil(
                                                  context, CupertinoPageRoute(
                                                      builder: (context) {
                                                return const MyHomePage();
                                              }), (route) => false);
                                            },
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(
                                          color:
                                              isCheck == false ? grey : mainClr,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
