import 'dart:developer';

import 'package:agora_new_updated/Database/listGirlfriendDatabase.dart';
import 'package:agora_new_updated/models/GirlFriendModel.dart';
import 'package:flutter/material.dart';

class PageViewController extends ChangeNotifier {
  String userName = "";
  String userGender = "Male";
  String dob = "";
  List<String> intrests = [];

  String girlFriendImage = "";
  String girlFriendName = '';
  String girlFriendGender = 'Female';
  int girlFriendAge = 18;
  String girlFriendPersonality = "";

//set username
  void setUsername(String name) {
    userName = name;
    notifyListeners();
  }

  //set usergender
  void setUserGender(String gender) {
    userGender = gender;

    notifyListeners();
  }

  //set user DOB
  void setUserDOB(String dateofBirth) {
    dob = dateofBirth;

    notifyListeners();
  }

  //set user intrest
  void setUserIntrest(String intrest) {
    if (intrests.contains(intrest)) {
      intrests.remove(intrest);
      log("intrest removed : [$intrests]");
    } else {
      if (intrests.length < 5) {
        intrests.add(intrest);
        log("intrest add : $intrests");
      }
    }
    notifyListeners();
  }

  //set AIGirlFriendImage
  void setGirlFriendImage(String image) {
    girlFriendImage = image;
    log("image path is : $girlFriendImage");
    notifyListeners();
  }

  //set setGirlFriendName
  void setGirlFriendName(String name) {
    girlFriendName = name;
    notifyListeners();
  }

  //set setGirlFriendGender
  void setGirlFriendGender(String gender) {
    girlFriendGender = gender;

    notifyListeners();
  }

  //set setGirlFriendGender
  void setGirlFriendAge(int age) {
    girlFriendAge = age;

    notifyListeners();
  }

  //set setGirlFriend Personality
  void setGirlFriendPersonality(String personality) {
    girlFriendPersonality = personality;
    notifyListeners();
  }

  //save girlfriend
  Future<void> saveGirlfriend() async {
    GirlFriend newGirlfriend = GirlFriend(
      userName: userName,
      userGender: userGender,
      dob: dob,
      interests: intrests,
      girlFriendImage: girlFriendImage,
      girlFriendName: girlFriendName,
      girlFriendGender: girlFriendGender,
      girlFriendAge: girlFriendAge,
      girlFriendPersonality: girlFriendPersonality,
    );

    // Save the new girlfriend to the database
    await GirlfriendDatabaseHelper().insertGirlfriend(newGirlfriend);
    notifyListeners();
  }
}
