import 'package:flutter/material.dart';
import 'constants.dart';

class ShowLocation extends StatelessWidget {
  ShowLocation({required this.latitude, required this.longitude});
  final String latitude, longitude;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = (MediaQuery.of(context).size.height);
    return Scaffold(
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
