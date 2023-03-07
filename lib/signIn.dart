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
  late String email, password;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: w / 10, vertical: h / 40),
              child: TextFormField(
                decoration: InputDecoration(hintText: "email"),
                onChanged: ((value) {
                  email = value!;
                }),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: w / 10, vertical: h / 40),
              child: TextFormField(
                decoration: InputDecoration(hintText: "password"),
                onChanged: ((value) {
                  password = value!;
                }),
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
                // signIn();
              },
            )
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
