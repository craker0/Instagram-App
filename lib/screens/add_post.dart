

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/firebase_services/firestore.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:insta/shared/colors.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';
class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? imgPath;
  String? imgName;
  bool isLoading = false;
  final desController = TextEditingController();

  upLoadImg2Screen(ImageSource src) async {
    Navigator.pop(context);
    final pickedImg = await ImagePicker().pickImage(source: src);

    if (pickedImg != null) {
      imgPath = await pickedImg.readAsBytes();
      setState(() {
        imgName = basename(pickedImg.path);
        int random = Random().nextInt(999999999);
        imgName = "$random$imgName";
      });
    }
    if (!mounted) return;
  }

  showModel() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(88, 22, 12, 78),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: primaryColor)),
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await upLoadImg2Screen(ImageSource.camera);
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 55,
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await upLoadImg2Screen(ImageSource.gallery);
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.photo_album,
                            size: 55,
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;
    return imgPath == null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
                child: IconButton(
                    onPressed: () {
                      showModel();
                    },
                    icon: const Icon(
                      Icons.upload,
                      size: 66,
                    ))),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      imgPath = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await FirestoreMethods().upLoadPost(
                          imgName: imgName,
                          imgPath: imgPath,
                          description: desController.text,
                          profileImg: allDataFromDB!.profileImg,
                          userName: allDataFromDB.username,
                          context: context);
                      setState(() {
                        isLoading = false;
                        imgPath = null;
                      });
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 19),
                    ))
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 17,
                ),
                isLoading
                    ? const LinearProgressIndicator()
                    : const Divider(
                        thickness: 0.6,
                      ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 37,
                      backgroundImage: NetworkImage(allDataFromDB!.profileImg.toString()),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        maxLines: 8,
                        controller: desController,
                        decoration: const InputDecoration(
                            hintText: "Write a Caption ...",
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      height: 66,
                      width: 74,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(
                                imgPath!,
                              ),
                              fit: BoxFit.cover)),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
