import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  const TextWidget({
    required this.size,
    required this.text,
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.irishGrover(
        fontSize: size.sp,
        color: color ?? whiteColor,
      ),
    );
  }
}
