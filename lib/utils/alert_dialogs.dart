import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showException(String errorMsg, context, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color ?? black,
    content: Text(errorMsg),
    duration: const Duration(seconds: 3),
  ));
}

showToast(String msg) {
  Fluttertoast.showToast(msg: msg);
}

showClearChatDialog(
    BuildContext context, String title, String des, VoidCallback onTap,
    {String? yes, String? no}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: scaffoldBackground, // Background color
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                des,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  // primary: Colors.white, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    yes ?? 'Clear Chat History',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text(
                  no ?? 'Cancel',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
