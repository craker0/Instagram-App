
import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String profileImg;
  final String username;
  final String description;
  final String imgPost;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final List likes;
  PostData(
      {required this.username,
      required this.imgPost,
      required this.datePublished,
      required this.uid,
      required this.profileImg,
      required this.description,
      required this.postId,
      required this.likes});

  Map<String, dynamic> covert2Map() {
    return {
      "username": username,
      "imgPost": imgPost,
      "datePublished": datePublished,
      "description": description,
      "profileImg": profileImg,
      "uid": uid,
      "likes": likes,
      "postId": postId
    };
  }

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostData(
      profileImg: snapshot["profileImg"],
      username: snapshot["username"],
      description: snapshot["description"],
      imgPost: snapshot["imgPost"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["likes"],
    );
  }
}
