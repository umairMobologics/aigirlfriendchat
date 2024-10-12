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

  String? id; // Primary ID for read purposes

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
    this.id, // Optional, can be null during creation and assigned later
  });

  // Convert a GirlFriend object into a Map object
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

  // Extract a GirlFriend object from a Map object
  factory GirlFriend.fromMap(Map<String, dynamic> map, {String? id}) {
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
      id: id, // Assigning the ID if provided
    );
  }
}
