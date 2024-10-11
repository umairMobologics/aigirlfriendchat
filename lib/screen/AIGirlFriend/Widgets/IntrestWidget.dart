import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntrestWidget extends StatelessWidget {
  const IntrestWidget({
    super.key,
    required this.items,
  });

  final String items;

  @override
  Widget build(BuildContext context) {
    var pageController = Provider.of<PageViewController>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        pageController.setUserIntrest(items);
      },
      child: Consumer<PageViewController>(
        builder: (context, value, child) => Ink(
          // color: Colors.blue, // color of grid items

          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: value.intrests.contains(items)
                  ? mainClr
                  : const Color.fromARGB(255, 2, 36, 66),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: white54, width: 0.3)),
          child: Text(
            items,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
