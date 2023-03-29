import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class EventButton extends StatelessWidget {
  const EventButton({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: w / 20, vertical: h / 40),
          height: h / 15,
          width: w / 3,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            'Event',
            style: GoogleFonts.openSans(
                color: white, fontSize: 20, fontWeight: FontWeight.w600),
          ))),
      onTap: () {},
    );
  }
}
