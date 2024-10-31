



import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/Responsive/mobilescreen.dart';
import 'package:insta/Responsive/responsive.dart';
import 'package:insta/Responsive/webscreen.dart';
import 'package:insta/firebase_services/auth.dart';
import 'package:insta/screens/login.dart';
import 'package:insta/shared/colors.dart';
import 'package:insta/shared/feild_decoration.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final userNameController = TextEditingController();

  final passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isHidden = true;

  Uint8List? imgPath;
  String? imgName;

  upLoadImg2Screen(ImageSource src) async {
    final pickedImg = await ImagePicker().pickImage(source: src);

    if (pickedImg != null) {
      imgPath = await pickedImg.readAsBytes();
      setState(() {
        imgName = basename(pickedImg.path);
        int random = Random().nextInt(999999999);
        imgName = "$random$imgName";
      });
    }
    if(!mounted)return;
    Navigator.pop(context);
  }

  onClickRegister() async {
    if (_formKey.currentState!.validate() &&
        imgName != null &&
        imgPath != null) {
      setState(() {
        isLoading = true;
      });
      await AuthMethods().register(
          email: emailController.text,
          password: passController.text,
          title: titleController.text,
          username: userNameController.text,
          imgName: imgName,
          imgPath: imgPath, context: context);
      setState(() {
        isLoading = false;
      });
    if(!mounted)return;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Responsive(
                  mobileScreen: MobileScreen(), webScreen: WebScreen())));
    }
  }

  showModel() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
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
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
    userNameController.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Register"),
      ),
      body: Center(
        child: Padding(
          padding: widthScreen > 600
              ? EdgeInsets.symmetric(horizontal: widthScreen / 4, vertical: 11)
              : const EdgeInsets.symmetric(horizontal: 30, vertical: 11),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      imgPath == null
                          ? CircleAvatar(
                              radius: 78,
                              backgroundColor:
                                  const Color.fromARGB(87, 255, 255, 255),
                              child: ClipOval(
                                  child: Image.asset(
                                "assets/img/avatar.png",
                              )),
                            )
                          : CircleAvatar(
                              radius: 78,
                              backgroundImage: MemoryImage(imgPath!),
                            ),
                      Positioned(
                          bottom: -10,
                          right: -10,
                          child: IconButton(
                              onPressed: () async {
                                await showModel();
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                size: 28,
                                color: primaryColor,
                              )))
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  TextFormField(
                    validator: (value) {
                      return value!.isEmpty ? "Can't be Empty" : null;
                    },
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.name,
                    controller: userNameController,
                    decoration: feildDecoration.copyWith(
                        hintText: "Enter Your Name",
                        suffixIcon: const Icon(Icons.person)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      return value!.isEmpty ? "Can't be Empty" : null;
                    },
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    controller: titleController,
                    decoration: feildDecoration.copyWith(
                        hintText: "Enter Your Title",
                        suffixIcon: const Icon(Icons.description_outlined)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (email) {
                      return email!.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                          ? null
                          : "Enter a valid email";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: feildDecoration.copyWith(
                        hintText: "Enter Your E-Mail",
                        suffixIcon: const Icon(Icons.email)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      return value!.length < 8
                          ? "Enter alt least 8 letters"
                          : null;
                    },
                    controller: passController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    obscureText: isHidden ? true : false,
                    decoration: feildDecoration.copyWith(
                        hintText: "Enter Your Password",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: isHidden
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility))),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await onClickRegister();
                      },
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: const BorderSide(
                                  width: 0.54, color: primaryColor))),
                          backgroundColor:
                              const WidgetStatePropertyAll(mobileBackgroundColor),
                          padding: WidgetStatePropertyAll(widthScreen > 600
                              ? const EdgeInsets.symmetric(
                                  horizontal: 27, vertical: 12)
                              : const EdgeInsets.symmetric(
                                  horizontal: 27, vertical: 6))),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.blueAccent,
                            )
                          : const Text(
                              "Register",
                              style:
                                  TextStyle(fontSize: 24, color: primaryColor),
                            )),
                  const SizedBox(
                    height: 11,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Do You have an account ?",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
