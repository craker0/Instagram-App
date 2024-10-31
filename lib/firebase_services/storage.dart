

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';



getImgUrl({
  required String imgName,
  required Uint8List imgPath,
  required String floderName,
}) async {
  final storageRef = FirebaseStorage.instance.ref("$floderName/$imgName");
  UploadTask uploadTask = storageRef.putData(imgPath);
  TaskSnapshot snap = await uploadTask;

  String urll = await snap.ref.getDownloadURL();

  return urll;
}
