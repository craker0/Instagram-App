



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/shared/colors.dart';
import 'package:insta/shared/post_design.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor:
            widthScreen > 600 ? webBackgroundColor : mobileBackgroundColor,
        appBar: widthScreen > 600
            ? null
            : AppBar(
                backgroundColor: mobileBackgroundColor,
                title: SvgPicture.asset(
                  "assets/img/instagram.svg",
                  
                  height: 32,
                ),
                actions: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.messenger_outline)),
                  IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout_outlined)),
                ],
              ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
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

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return PostDesign(data: data);
              }).toList(),
            );
          },
        ));
  }
}
