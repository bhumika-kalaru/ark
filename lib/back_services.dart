import 'dart:async';

import 'package:background_service/background_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

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

// void registerBackground() {
//   BackgroundFetch.registerHeadlessTask(backgroundFunction);
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//       androidConfiguration: AndroidConfiguration(
//           onStart: onStart, isForegroundMode: true, autoStart: true));
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   return true;
// }

// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   if (service is AndroidServiceInstance) {
//     // service.on('setAsForeground').listen((event) {
//     //   service.setAsForegroundService();
//     // });
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//   Timer.periodic(Duration(minutes: 5), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         service.setForegroundNotificationInfo(
//             title: "title", content: "content");
//       }
//     }
//     late String lat, long;
//     print("backgrounfunctionstart");
//     _getLocation().then(((value) async {
//       lat = '${value.latitude}';
//       long = '${value.longitude}';
//       // setState(() async {
//       bool? isGranted = await PermissionHandler.permissionsGranted;
//       try {
//         if (!isGranted!) {
//           // Opens the Do Not Disturb Access settings to grant the access
//           await PermissionHandler.openDoNotDisturbSetting();
//         } else {
//           String? lati, longi;
//           var document = await FirebaseFirestore.instance.collection('Location');
//           var all = await document.get();
//           var firstId = all.docs.first.id;
//           var document2 = (await FirebaseFirestore.instance
//               .collection('Location')
//               .doc(firstId)
//               .get());
//           if (document2.exists) {
//             Map<String, dynamic>? data = document2.data();
//             lati = data?['latitude'];
//             longi = data?['longitude'];
//             print("exists");
//             print(lat);
//             print(" ");
//             print(lati);
//           }

//           double distanceInMeters = Geolocator.distanceBetween(double.parse(lat),
//               double.parse(long), double.parse(lati!), double.parse(longi!));
//           //   print(distanceInMeters);
//           if (distanceInMeters < 100) {
//             await SoundMode.setSoundMode(RingerModeStatus.silent);
//           }
//         }
//       } on PlatformException {
//         print('Please enable permissions required');
//       }
//       // });
//     }));

//     print("background service running");
//     service.invoke('update');
//   });
// }

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = BackgroundService();
  service.onDataReceived.listen((event) {
    // if (event!["action"] == "setAsForeground") {
    //   service.setForegroundMode(true);
    //   return;
    // }

    if (event!["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }
    late String lat, long;
    print("backgrounfunctionstart");
    _getLocation().then(((value) async {
      lat = '${value.latitude}';
      long = '${value.longitude}';
      // setState(() async {
      bool? isGranted = await PermissionHandler.permissionsGranted;
      try {
        if (!isGranted!) {
          // Opens the Do Not Disturb Access settings to grant the access
          await PermissionHandler.openDoNotDisturbSetting();
        } else {
          String? lati, longi;
          var document =
              await FirebaseFirestore.instance.collection('Location');
          var all = await document.get();
          var firstId = all.docs.first.id;
          var document2 = (await FirebaseFirestore.instance
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
      // });
    }));
  });
  // }

  // if (event["action"] == "stopService") {
  //   service.stopBackgroundService();
  // }

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );

    service.sendData(
      action: DateTime.now().toIso8601String(),
    );
  });
}
