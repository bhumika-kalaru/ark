import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:background_service/background_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

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

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  print("backgrounfunctionstart");
  final service = BackgroundService();
  service.onDataReceived.listen((event) async {
    if (event!["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }
    service.setForegroundMode(true);
    Timer.periodic(Duration(seconds: 15), (timer) async {
      print("43");
      late String lat, long;
      await Firebase.initializeApp();
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      print("47");
      try {
        Position position = await _getLocation();
        print("get location start");
        lat = '${position.latitude}';
        long = '${position.longitude}';
        bool? isGranted = await PermissionHandler.permissionsGranted;
        if (!isGranted!) {
          print("56-isgranted  ");
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
          print(distanceInMeters);
          if (distanceInMeters < 100) {
            await SoundMode.setSoundMode(RingerModeStatus.silent);
            bool? isGranted = await PermissionHandler.permissionsGranted;
            print(SoundMode.ringerModeStatus);
            print("hello");
            if (!isGranted!) {
              // Opens the Do Not Disturb Access settings to grant the access
              await PermissionHandler.openDoNotDisturbSetting();
            } else {
              try {
                await SoundMode.setSoundMode(RingerModeStatus.silent);
              } on PlatformException {
                print('Please enable permissions required');
              }
            }
          }
        }
      } on PlatformException {
        print('Please enable permissions required');
      }
    });

    service.setNotificationInfo(
      title: "Ark Running in background",
      content: "Updated at ${DateTime.now()}",
    );

    service.sendData(
      action: "setAsBackground",
    );
  });
}
