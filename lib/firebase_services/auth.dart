import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/firebase_services/storage.dart';
import 'package:insta/models/user.dart';
import 'package:insta/shared/snackbar.dart';

class AuthMethods {
  register(
      {required email,
      required password,
      required title,
      required imgName,
      required imgPath,
      required username,
      required context}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // get url for profileImg
      String url = await getImgUrl(
          imgName: imgName,
          imgPath: imgPath,
          floderName: 'ProfileImg/${FirebaseAuth.instance.currentUser!.uid}');

      // pick data to database
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      UserData user = UserData(
          email: email,
          password: password,
          title: title,
          username: username,
          profileImg: url,
          uid: credential.user!.uid,
          followers: [],
          following: []);
      users.doc(credential.user!.uid).set(user.covert2Map());
    } on FirebaseAuthException catch (e) {
      return showSnackBar(context, "ERROR => ${e.code}");
    } catch (e) {
      null;
    }
  }

  logInFunc({
    required email,
    required password,
    required context,
  }) async {
    try {
       await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      null;
    } catch (e) {
      null;
    }
  }

  Future<UserData> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserData.convertSnap2Model(snap);
  }
}
