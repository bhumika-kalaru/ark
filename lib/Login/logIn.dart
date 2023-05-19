import 'package:ark/Screens/eventScreen.dart';
import 'package:ark/Screens/mainScreen.dart';
import 'package:ark/Login/signIn.dart';
import 'package:ark/Widgets/eventButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return EventScreen(w: w, h: h);
          }
          return SignIn();
        },
      ),
    );
  }
}
