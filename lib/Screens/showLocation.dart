import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class ShowLocation extends StatelessWidget {
  ShowLocation({required this.latitude, required this.longitude});
  final String latitude, longitude;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = (MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Current Location Info",
          style: GoogleFonts.sourceSansPro(
              fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              latitude,
              style: Normal,
            ),
            Text(
              longitude,
              style: Normal,
            )
          ],
        ),
      )),
    );
  }
}
