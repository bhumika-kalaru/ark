import 'package:ark/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class profile extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.height;

    TextEditingController _nameOfPlaceController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: white,
          title: Text(
            'Profile',
            style: GoogleFonts.sourceSansPro(
                fontSize: 22, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
            ),
          )),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: h / 15,
                backgroundImage: AssetImage(
                  'images/flutter.png',
                ),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                user.email!,
                style: GoogleFonts.sourceSansPro(
                    fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
