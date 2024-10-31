

import 'package:flutter/material.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:provider/provider.dart';

class Responsive extends StatefulWidget {
   final Widget mobileScreen;
   final Widget webScreen;

  const Responsive(
      {super.key, required this.mobileScreen, required this.webScreen});

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {

  // To get data from DB using provider
 getDataFromDB() async {
 UserProvider userProvider = Provider.of(context, listen: false);
 await userProvider.refreshUser();
 }
 
 
 @override
 void initState() {
    super.initState();
    getDataFromDB();
 }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ( BuildContext buildContext, BoxConstraints boxConstraints) {
      if (boxConstraints.maxWidth < 600) {
        return widget.mobileScreen;
      } else {
        return widget.webScreen;
      }
    });
  }
}
