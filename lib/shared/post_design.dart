

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/firebase_services/firestore.dart';
import 'package:insta/screens/comments.dart';
import 'package:insta/shared/colors.dart';
import 'package:insta/shared/heart_animation.dart';
import 'package:intl/intl.dart';

class PostDesign extends StatefulWidget {
  final Map data;
  const PostDesign({super.key, required this.data});

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  int commentCount = 0;
  bool isLikeAnimating = false;

  getCommentCount() async {
    try {
      QuerySnapshot commentData = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.data['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentCount = commentData.docs.length;
      });
    } catch (e) {
    null;
    }
  }

  deletePost() async {
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.data['postId'])
        .delete();
    if (!mounted) return;
    Navigator.pop(context);
  }

  showModel() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: const EdgeInsets.all(8),
            children: [
              FirebaseAuth.instance.currentUser!.uid == widget.data['uid']
                  ? SimpleDialogOption(
                      onPressed: () async {
                        await deletePost();
                      },
                      child: const Text(
                        "Delete Post",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  : const SimpleDialogOption(
                      child: Text(
                        "Can't Delete Post",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 17),
                ),
              )
            ],
          );
        });
  }

  onImgPostClick() async {
    setState(() {
      isLikeAnimating = true;
    });
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.data['postId'])
        .update({
      'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  @override
  void initState() {
    super.initState();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 11, bottom: 11),
        width: widthScreen > 600 ? widthScreen / 2 : double.infinity,
        decoration: BoxDecoration(
            color: mobileBackgroundColor,
            borderRadius: BorderRadius.circular(11)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 11, 9, 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage:
                            NetworkImage(widget.data["profileImg"].toString()),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(widget.data["username"].toString()),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        showModel();
                      },
                      icon: const Icon(Icons.more_vert))
                ],
              ),
            ),
            Stack(
              children: [
                GestureDetector(
                  onDoubleTap: () async {
                    await onImgPostClick();
                  },
                  child: Image.network(
                    widget.data['imgPost'].toString(),
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : SizedBox(
                              height: widthScreen > 600
                                  ? MediaQuery.of(context).size.height * 0.5
                                  : MediaQuery.of(context).size.height * 0.25,
                              width: double.infinity,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                            );
                    },
                    height: widthScreen > 600
                        ? MediaQuery.of(context).size.height * 0.5
                        : MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 122,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeAnimation(
                        smallLike: true,
                        isAnimating: widget.data['likes']
                            .contains(FirebaseAuth.instance.currentUser!.uid),
                        child: IconButton(
                            onPressed: () async {
                              await FirestoreMethods()
                                  .toggleLike(data: widget.data);
                            },
                            icon: widget.data['likes'].contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(Icons.favorite_border))),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CommentsScreen(
                                        data: widget.data,
                                        showTextFeild: true,
                                      ))));
                        },
                        icon: const Icon(Icons.comment_outlined)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                  ],
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(9, 0, 9, 9),
              child: Text(
                widget.data['likes'].length <= 1
                    ? "${widget.data['likes'].length} Like"
                    : "${widget.data['likes'].length} Likes",
                style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 219, 216, 207)),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(9, 0, 9, 9),
              child: Row(
                children: [
                  Text(
                    widget.data["username"].toString(),
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 255, 255, 255)),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.data["description"].toString(),
                    style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 255, 255, 255)),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              data: widget.data,
                              showTextFeild: false,
                            )));
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(9, 0, 9, 9),
                child: Text(
                  "View all $commentCount comments",
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 214, 212, 206)),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(9, 0, 9, 9),
              child: Text(
                DateFormat('MMMM d, ' 'y')
                    .format(widget.data["datePublished"].toDate()),
                style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 214, 212, 206)),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
