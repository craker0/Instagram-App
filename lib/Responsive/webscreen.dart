


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/screens/add_post.dart';
import 'package:insta/screens/home.dart';
import 'package:insta/screens/profile.dart';
import 'package:insta/screens/search.dart';
import 'package:insta/shared/colors.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final _pageController = PageController();
  int currentPage = 0;

  navigate2screen(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      currentPage = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: webBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/img/instagram.svg",
      
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigate2screen(0);
            },
            icon: const Icon(Icons.home),
            color:currentPage == 0 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () {
              navigate2screen(1);
            },
            icon: const Icon(Icons.search),
            color:currentPage == 1 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () {
              navigate2screen(2);
            },
            icon: const Icon(Icons.add_a_photo),
        color:currentPage == 2 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () {
              navigate2screen(3);
            },
            icon: const Icon(Icons.favorite),
            color:currentPage == 3 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () {
              navigate2screen(4);
            },
            icon: const Icon(Icons.person),
          color:currentPage == 4 ? primaryColor : secondaryColor,
          ),
        ],
      ),
      body: Center(
        child: PageView(
          controller: _pageController,
          children: [
            const Home(),
            const Search(),
            const AddPost(),
            const Center(child: Text("Love U <3")),
            Profile(uid: FirebaseAuth.instance.currentUser!.uid,)
          ],
        ),
      ),
    );
  }
}