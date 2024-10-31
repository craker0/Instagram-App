

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/screens/add_post.dart';
import 'package:insta/screens/home.dart';
import 'package:insta/screens/profile.dart';
import 'package:insta/screens/search.dart';
import 'package:insta/shared/colors.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final _pageController = PageController();
  int currentPage = 0;
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CupertinoTabBar(
            onTap: (value) {
              _pageController.jumpToPage(value);
              setState(() {
                currentPage = value;
              });
            },
            backgroundColor: mobileBackgroundColor,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: currentPage == 0 ? primaryColor : secondaryColor,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: currentPage == 1 ? primaryColor : secondaryColor,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle,
                    color: currentPage == 2 ? primaryColor : secondaryColor,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: currentPage == 3 ? primaryColor : secondaryColor,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: currentPage == 4 ? primaryColor : secondaryColor,
                  ),
                  label: ''),
            ]),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
          

            const Home(),
            const Search(),
            const AddPost(),
            const Center(child: Text("Love U <3")),
            Profile(uid: FirebaseAuth.instance.currentUser!.uid,)
          ],
        ));
  }
}
