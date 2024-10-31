

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/shared/colors.dart';

class Profile extends StatefulWidget {
  final String uid;
  const Profile({super.key, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

late String message;

class _ProfileState extends State<Profile> {
  Map userData = {};
  bool isLoading = true;
  int fllowers = 0;
  int following = 0;
  int psotCount = 0;
  bool isFollowing = false;


  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      userData = snapshot.data()!;
      fllowers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      QuerySnapshot<Map<String, dynamic>> snapshotPost = await FirebaseFirestore
          .instance
          .collection('Posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      psotCount = snapshotPost.docs.length;
    } catch (e) {
      null;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return isLoading
        ? const Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            )),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username'].toString()),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(left: 14, top: 7),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 28, 25, 39)),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage(userData['profileImg'].toString()),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                psotCount.toString(),
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Posts",
                                style: TextStyle(fontSize: 19),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                fllowers.toString(),
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(fontSize: 19),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                following.toString(),
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(fontSize: 19),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 15, left: 20),
                    width: double.infinity,
                    child: Text(userData['title'].toString())),
                const SizedBox(
                  height: 11,
                ),
                const Divider(
                  color: secondaryColor,
                  thickness: 0.44,
                ),
                const SizedBox(
                  height: 11,
                ),
                widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text(
                              "Edit Profile",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: secondaryColor,
                            ),
                            style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(
                                    mobileBackgroundColor),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                                255, 105, 94, 94)),
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: widthScreen > 600 ? 14 : 0))),
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text(
                              "Log Out",
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor),
                            ),
                            icon: const Icon(
                              Icons.logout_outlined,
                              color: primaryColor,
                            ),
                            style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color.fromARGB(143, 255, 55, 112)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: widthScreen > 600 ? 14 : 0))),
                          ),
                        ],
                      )
                    : isFollowing != true
                        ? ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isFollowing = true;
                                fllowers++;
                              });
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(widget.uid)
                                  .update({
                                "followers": FieldValue.arrayUnion(
                                    [FirebaseAuth.instance.currentUser!.uid])
                              });

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "following": FieldValue.arrayUnion([widget.uid])
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color.fromARGB(255, 19, 14, 88)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 70,
                                        vertical: widthScreen > 600 ? 17 : 8))),
                            child: const Text(
                              "Follow",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                fllowers--;
                                isFollowing = false;
                              });

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(widget.uid)
                                  .update({
                                "followers": FieldValue.arrayRemove(
                                    [FirebaseAuth.instance.currentUser!.uid])
                              });

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "following":
                                    FieldValue.arrayRemove([widget.uid])
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color.fromARGB(255, 88, 14, 14)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 61,
                                        vertical: widthScreen > 600 ? 17 : 8))),
                            child: const Text(
                              "Unfollow",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                            ),
                          ),
                const SizedBox(
                  height: 17,
                ),
                const Divider(
                  color: secondaryColor,
                  thickness: 0.44,
                ),
                const SizedBox(
                  height: 17,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widthScreen > 600 ? 66 : 0),
                          child: GridView.builder(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    snapshot.data.docs[index]["imgPost"],
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : const Center(
                                              child: CircularProgressIndicator(
                                                color: primaryColor,
                                              ),
                                            );
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }),
                        ),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }
}
