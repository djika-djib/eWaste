class UserModel {
  String name;
  String email;
  String bio;
  String userRole;
  String profilePic;
  // String createdAt;
  String phoneNumber;
  String uid;

  UserModel(
      {required this.name,
      required this.email,
      required this.bio,
      required this.userRole,
      required this.profilePic,
      // required this.createdAt,
      required this.phoneNumber,
      required this.uid});

  // getting from Map(server)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        bio: map['bio'] ?? '',
        userRole: map['userRole'] ?? '',
        profilePic: map['profilePic'] ?? '',
        // createdAt: map['createdAt'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        uid: map['uid'] ?? '');
  }

  // sending To map(server)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "bio": bio,
      "userRole": userRole,
      "profilePic": profilePic,
      // "createdAt": createdAt,
      "phoneNumber": phoneNumber,
      "uid": uid,
    };
  }
}
