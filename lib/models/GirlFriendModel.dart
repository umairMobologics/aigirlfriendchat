class GirlFriend {
  final String userName;
  final String userGender;
  final String dob; // Date of Birth in String format
  final List<String> interests;

  final String girlFriendImage;
  final String girlFriendName;
  final String girlFriendGender;
  final int girlFriendAge;
  final String girlFriendPersonality;

  GirlFriend({
    required this.userName,
    required this.userGender,
    required this.dob,
    required this.interests,
    required this.girlFriendImage,
    required this.girlFriendName,
    required this.girlFriendGender,
    required this.girlFriendAge,
    required this.girlFriendPersonality,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userGender': userGender,
      'dob': dob,
      'interests': interests.join(','), // Joining list into a string
      'girlFriendImage': girlFriendImage,
      'girlFriendName': girlFriendName,
      'girlFriendGender': girlFriendGender,
      'girlFriendAge': girlFriendAge,
      'girlFriendPersonality': girlFriendPersonality,
    };
  }

  // Extract a User object from a Map object
  factory GirlFriend.fromMap(Map<String, dynamic> map) {
    return GirlFriend(
      userName: map['userName'],
      userGender: map['userGender'],
      dob: map['dob'],
      interests:
          map['interests'].split(','), // Splitting the string back into a list
      girlFriendImage: map['girlFriendImage'],
      girlFriendName: map['girlFriendName'],
      girlFriendGender: map['girlFriendGender'],
      girlFriendAge: map['girlFriendAge'],
      girlFriendPersonality: map['girlFriendPersonality'],
    );
  }
}
