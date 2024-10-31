import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/firebase_services/firestore.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:insta/shared/colors.dart';
import 'package:insta/shared/feild_decoration.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final Map data;
final  bool showTextFeild;
  const CommentsScreen({super.key, required this.data, required this.showTextFeild});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userCommentData = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Posts')
                .doc(widget.data['postId'])
                .collection('comments')
                .orderBy('datePiblish', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: CircleAvatar(
                                  radius: 33,
                                  backgroundImage:
                                      NetworkImage(data['profileImg']),
                                ),
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data['username'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      Text(
                                        data['textComment'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('MMMM d, ' 'y')
                                        .format(data['datePiblish'].toDate()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite))
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
          widget.showTextFeild
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundImage:
                                NetworkImage(userCommentData!.profileImg)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: feildDecoration.copyWith(
                              hintText:
                                  "Comment as ${userCommentData.username} : ",
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    await FirestoreMethods().uploadComment(
                                        postId: widget.data['postId'],
                                        uid: userCommentData.uid,
                                        username: userCommentData.username,
                                        profileImg: userCommentData.profileImg,
                                        commentText: commentController.text);
                                    commentController.clear();
                                  },
                                  icon: const Icon(Icons.send)),
                            )),
                      ),
                    ],
                  ),
                )
              : const Text("")
        ],
      ),
    );
  }
}
