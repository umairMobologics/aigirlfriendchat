import 'package:agora_new_updated/helper/const.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms And Conditions"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(child: Text(termsAndConditions)),
      ),
    );
  }
}
