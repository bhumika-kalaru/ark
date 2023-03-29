import 'package:ark/addEvent.dart';
import 'package:ark/location.dart';
import 'package:ark/logIn.dart';
import 'package:ark/pickFile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'constants.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.logout))
      ]),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Location(), FilePick(), EventButton()],
          ),
        ),
      ),
    );
  }
}
