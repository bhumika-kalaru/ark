import 'package:ark/logIn.dart';
import 'package:ark/verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matcher/matcher.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          // padding: EdgeInsets.symmetric(vertical: h / 40, horizontal: w / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // padding: EdgeInsets.symmetric(horizontal: double.infinity),
                child: Image.asset(
                  'images/programmer.png',
                  height: h / 4,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(h: h, w: w, txt: "LogIn", path: (LogIn())),
                  Button(h: h, w: w, txt: "SignUp", path: (Verify())),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  Button({
    Key? key,
    required this.h,
    required this.w,
    required this.txt,
    required this.path,
  });

  final double h;
  final double w;
  final String txt;
  Widget path;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(vertical: h / 80, horizontal: w / 40),
          height: h / 20,
          width: w / 3.5,
          decoration: BoxDecoration(
              color: blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              txt,
              style: GoogleFonts.openSans(color: white, fontSize: 20),
            ),
          )),
      onTap: (() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => path));
      }),
    );
  }
}
