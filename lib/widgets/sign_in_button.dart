import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

class SignInButton extends StatelessWidget {
  final String btnText;
  const SignInButton({
    required this.btnText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Center(
        child: Text(
          btnText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: whiteColor,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
