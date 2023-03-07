import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'package:flutter/material.dart';

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
            onTap: () {
              setState(() {
                signIn();
              });
            },
          )
        ],
      ),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
        .catchError((error) => print(error));
    ;
  }
}
