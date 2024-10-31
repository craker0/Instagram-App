

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/firebase_services/auth.dart';
import 'package:insta/screens/register.dart';
import 'package:insta/shared/colors.dart';
import 'package:insta/shared/feild_decoration.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isHidden = true;

  onLoginClick() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await AuthMethods().logInFunc(
          email: emailController.text,
          password: passwordController.text,
          context: context);
      setState(() {
        isLoading = false;
      });
    }
    
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Log in"),
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
                  TextFormField(
                      validator: (email) {
                        return email!.contains(RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                            ? null
                            : "Enter a vaild email";
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: feildDecoration.copyWith(
                        hintText: "Enter Your E-Mail",
                        suffixIcon: const Icon(Icons.email),
                      )),
                  const SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                      validator: (value) {
                        return value!.length < 8
                            ? "Enter 8 letters at least"
                            : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      
                      textInputAction: TextInputAction.done,
                      obscureText:  isHidden
                                ? true:false,
                      decoration: feildDecoration.copyWith(
                          hintText: "Enter Your Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: isHidden
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ))),
                  const SizedBox(
                    height: 17,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        onLoginClick();
                      },
                      style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                              Color.fromARGB(255, 32, 5, 82)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                          padding: WidgetStatePropertyAll(widthScreen > 600
                              ? const EdgeInsets.symmetric(
                                  horizontal: 29, vertical: 16)
                              : const EdgeInsets.symmetric(
                                  horizontal: 29, vertical: 8))),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: primaryColor,
                            )
                          : const Text(
                              "Login",
                              style:
                                  TextStyle(fontSize: 20, color: primaryColor),
                            )),
                  const SizedBox(
                    height: 1,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forget Your Password ?",
                        style: TextStyle(fontSize: 15),
                      )),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                color: Colors.white),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: primaryColor,
                          thickness: 0.44,
                          height: 1,
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(fontSize: 15),
                      ),
                      Expanded(
                        child: Divider(
                          color: primaryColor,
                          thickness: 0.44,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: 55,
                        height: 55,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: primaryColor,
                            ),
                            shape: BoxShape.circle),
                        child: SvgPicture.asset("assets/img/google.svg")),
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
