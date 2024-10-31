

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta/Responsive/mobilescreen.dart';
import 'package:insta/Responsive/responsive.dart';
import 'package:insta/Responsive/webscreen.dart';
import 'package:insta/firebase_options.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:insta/screens/login.dart';
import 'package:insta/shared/colors.dart';
import 'package:insta/shared/snackbar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCgvXHVHt913QNaYi3ZmhM6Ig2TcfweKzw",
            authDomain: "insta-7d7a2.firebaseapp.com",
            projectId: "insta-7d7a2",
            storageBucket: "insta-7d7a2.appspot.com",
            messagingSenderId: "706866247395",
            appId: "1:706866247395:web:09b1b5fd729e2db49577d6"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return showSnackBar(context, "Something went wrong");
                } else if (snapshot.hasData) {
                  return const Responsive(
                      mobileScreen: MobileScreen(), webScreen: WebScreen());
                } else {
                  return const Login();
                }
              })),
    );
  }
}
