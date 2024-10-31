

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/firebase_services/storage.dart';
import 'package:insta/models/post.dart';
import 'package:insta/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  upLoadPost(
      {required imgName,
      required imgPath,
      required description,
      required profileImg,
      required userName,
      required context,
      required}) async {
    try {
      // get url for profileImg
      String url = await getImgUrl(
          imgName: imgName,
          imgPath: imgPath,
          floderName: 'PostImg/${FirebaseAuth.instance.currentUser!.uid}');

      // pick data to database
      CollectionReference posts =
          FirebaseFirestore.instance.collection('Posts');
      String newId = const Uuid().v1();
      PostData postData = PostData(
          username: userName,
          imgPost: url,
          datePublished: DateTime.now(),
          uid: FirebaseAuth.instance.currentUser!.uid,
          profileImg: profileImg,
          description: description,
          postId: newId,
          likes: []);
      posts
          .doc(newId)
          .set(postData.covert2Map())
          ;
    } on FirebaseAuthException catch (e) {
      return showSnackBar(context, "ERROR => ${e.code}");
    } catch (e) {
    null;
    }
  }

  uploadComment({
    required postId,
    required uid,
    required username,
    required profileImg,
    required commentText,
  }) async {
    if (commentText.isNotEmpty) {
      String commentId = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'uid': uid,
        'username': username,
        'profileImg': profileImg,
        'datePiblish': DateTime.now(),
        'textComment': commentText,
        'commentId': commentId,
      });
    } else {
    null;
    }
  }

  toggleLike({required data}) async {
    try {
      if (data['likes']
          .contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(data['postId'])
            .update({
          'likes':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(data['postId'])
            .update({
          'likes':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } catch (e) {
      null;
    }
  }
}
