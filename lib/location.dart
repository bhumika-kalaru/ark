import 'package:ark/showLocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late String lat, long;
  Future<Position> _getLocation() async {
    bool servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print('disabled location');
      return Future.error("Location service permission disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("permission Denied forever");
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = (MediaQuery.of(context).size.height);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: GestureDetector(
          child: Container(
              height: h / 15,
              width: w / 6,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                'Get Location',
                style: GoogleFonts.openSans(
                    color: white, fontSize: 20, fontWeight: FontWeight.w600),
              ))),
          onTap: (() {
            _getLocation().then(((value) {
              lat = '${value.latitude}';
              long = '${value.longitude}';
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowLocation(latitude: lat, longitude: long)));
              });
            }));
          }),
        ),
      ),
    );
  }
}
