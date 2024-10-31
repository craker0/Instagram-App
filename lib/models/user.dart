import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String username;
  String title;
  String email;
  String password;
  String profileImg;
  String uid;
  List following;
  List followers;
  UserData(
      {required this.email,
      required this.password,
      required this.followers,
      required this.following,
      required this.title,
      required this.uid,
      required this.profileImg,
      required this.username});

  Map<String, dynamic> covert2Map() {
    return {
      "username": username,
      "title": title,
      "email": email,
      "password": password,
      "profileImg": profileImg,
      "uid": uid,
      "following": [],
      "followers": []
    };
  }

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
        email: snapshot["email"],
        password: snapshot['password'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        title: snapshot['title'],
        uid: snapshot['uid'],
        profileImg: snapshot['profileImg'],
        username: snapshot['username']);
  }
}
