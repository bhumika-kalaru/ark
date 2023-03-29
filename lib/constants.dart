import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// late double height, width;
final Normal = GoogleFonts.montserrat(fontSize: 40);

final Color? white = Colors.white;
final Color? blue = Colors.blue;
final Color? black = Colors.black;

List<BoxShadow> blueShadow = [
  BoxShadow(
      color: Colors.lightBlue[100]!, blurRadius: 20, offset: Offset(0, 10))
];




// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = (MediaQuery.of(context).size.height);
//     return Container();
//   }
// }
