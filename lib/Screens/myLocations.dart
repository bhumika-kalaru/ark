import 'package:ark/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLocations extends StatelessWidget {
  late String lat, long;
  // const MyLocations({super.key});

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
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              child: StreamBuilder<List<location>>(
                stream: readUsers(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong! ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final times = snapshot.data!;
                    return ListView(
                      children: times.map(buildLocation).toList(),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getLocation().then(((value) {
              lat = '${value.latitude}';
              long = '${value.longitude}';
              addLocation(latitude: lat, longitude: long);
            }));
          },
          child: Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget buildLocation(location current) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      height: 100,
      decoration: BoxDecoration(
          color: white,
          boxShadow: blueShadow,
          borderRadius: BorderRadius.circular(30)),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                current.latitude,
                style: GoogleFonts.overpass(fontSize: 20),
              ),
              Text(current.longitude,
                  style: GoogleFonts.overpass(fontSize: 20)),
            ],
          ),
          IconButton(
              onPressed: () {
                final doc = FirebaseFirestore.instance
                    .collection('Location')
                    .doc(current.id);
                doc.delete();
              },
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ))
        ],
      )),
    );
  }

  Stream<List<location>> readUsers() => FirebaseFirestore.instance
      .collection('Location')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => location.fromJson(doc.data())).toList());

  Future addLocation({
    required String latitude,
    required String longitude,
  }) async {
    final docLoc = FirebaseFirestore.instance.collection('Location').doc();
    final loc =
        location(id: docLoc.id, latitude: latitude, longitude: longitude);
    final json = loc.toJson();
    await docLoc.set(json);
  }
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
