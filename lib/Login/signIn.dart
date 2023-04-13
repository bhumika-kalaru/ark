import 'package:ark/Screens/mainScreen.dart';
import 'package:ark/Login/signUp.dart';
import 'package:ark/Login/verify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

import 'forgotPassword.dart';
import '../Screens/homePage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // late TextEditingController emailController, password_controller;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in "),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: w / 10, vertical: h / 40),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: w / 10, vertical: h / 40),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(hintText: "Password"),
            ),
          ),
          GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: h / 80),
                height: h / 25,
                width: w / 4,
                child: Center(
                    child: Text(
                  "Submit",
                  style: GoogleFonts.openSans(
                      color: white, fontWeight: FontWeight.w500, fontSize: 18),
                )),
                decoration: BoxDecoration(
                    color: blue, borderRadius: BorderRadius.circular(10)),
              ),
              onTap: () async {
                int size = emailController.text.length, flag = 1, j = 0;
                String s = "iiita.ac.in",
                    email = emailController.text.toString();
                for (int i = size - 11; i < size; i++) {
                  if (s[j] != email[i]) {
                    flag = 0;
                  }
                  j++;
                }
                if (flag == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Email doesn't belong to the community"),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      (Route<dynamic> route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("No user found for that email."),
                        backgroundColor: Colors.red,
                      ));
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Wrong Password"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                }
              }
              // {
              // setState(() {
              // signIn();
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => MainScreen()),
              //   (Route<dynamic> route) => false,
              // );
              // });
              // },
              ),
          GestureDetector(
            child: RichText(
                text: TextSpan(
                    text: 'Create an account?!',
                    style: GoogleFonts.openSans(color: black, fontSize: 16),
                    children: [
                  TextSpan(
                    text: "signUp",
                    style: GoogleFonts.openSans(color: blue, fontSize: 16),
                  )
                ])),
            onTap: (() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Verify()));
            }),
          ),
          GestureDetector(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: h / 100),
                child: Text(
                  "forgot password!",
                  style: GoogleFonts.openSans(color: blue, fontSize: 16),
                )),
            onTap: (() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
            }),
          )
        ],
      ),
    );
  }

  // Future signIn() async {
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //           email: emailController.text,
  //           password: passwordController.text,
  //         )
  //         .catchError((error) => print(error));
  //     ;
  //   } on FirebaseAuthException catch (e) {
  //     print(e);
  //   }
  // }
}
