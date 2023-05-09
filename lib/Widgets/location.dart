import 'dart:io';

import 'package:ark/Screens/showLocation.dart';
import 'package:background_service/background_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late String lat, long;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

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
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: w / 20, vertical: h / 40),
          height: h / 15,
          width: w / 3,
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
          setState(() async {
            BackgroundService().sendData(action: "setAsBackground");
            bool? isGranted = await PermissionHandler.permissionsGranted;
            print(SoundMode.ringerModeStatus);
            print("hellooooo");
            try {
              if (!isGranted!) {
                // Opens the Do Not Disturb Access settings to grant the access
                await PermissionHandler.openDoNotDisturbSetting();
              } else {
                String? lati, longi;
                var document = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('Location');
                var all = await document.get();
                var firstId = all.docs.first.id;
                var document2 = (await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('Location')
                    .doc(firstId)
                    .get());
                if (document2.exists) {
                  Map<String, dynamic>? data = document2.data();
                  lati = data?['latitude'];
                  longi = data?['longitude'];
                  print("exists");
                  print(lat);
                  print(" ");
                  print(lati);
                }

                double distanceInMeters = Geolocator.distanceBetween(
                    double.parse(lat),
                    double.parse(long),
                    double.parse(lati!),
                    double.parse(longi!));
                //   print(distanceInMeters);
                if (distanceInMeters < 100) {
                  await SoundMode.setSoundMode(RingerModeStatus.silent);
                }
              }
            } on PlatformException {
              print('Please enable permissions required');
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShowLocation(latitude: lat, longitude: long)));
          });
        }));
      }),
    );
  }

  Stream<List<location>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('Location')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => location.fromJson(doc.data())).toList());
}

class location {
  late String id;
  final String latitude, longitude;
  location({this.id = '', required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() =>
      {'id': id, 'latitude': latitude, 'longitude': longitude};
  static location fromJson(Map<String, dynamic> json) => location(
        id: json['id'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
