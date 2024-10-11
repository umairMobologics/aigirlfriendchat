import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  const CustomButton({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 255, 255, 255).withAlpha(60),
          blurRadius: 6.0,
          spreadRadius: 0.0,
          offset: const Offset(
            0.0,
            3.0,
          ),
        ),
      ], borderRadius: BorderRadius.circular(20), color: color ?? white),
      child: Text(
        textAlign: TextAlign.center,
        text,
        style: const TextStyle(
            color: black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
