import 'package:ark/Screens/profile.dart';
import 'package:ark/Widgets/eventButton.dart';
import 'package:ark/Widgets/location.dart';
import 'package:ark/Login/logIn.dart';
import 'package:ark/Widgets/pickFile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';
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
      drawer: Drawer(
          child: ListView(children: [
        ListTile(
          tileColor: white,
          title: Center(child: Text('Account')),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => profile()));
          },
        ),
      ])),
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
