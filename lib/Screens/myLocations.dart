import 'package:ark/Screens/showLocation.dart';
import 'package:ark/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLocations extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String lat, long;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Your Locations",
            style: GoogleFonts.sourceSansPro(
                fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
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
          onPressed: () async {
            int flag = 0;
            String? nameOfPlace;
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('choose a Landmark name...'),
                  content: TextField(
                    onChanged: (value) {
                      nameOfPlace = value;
                    },
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        flag = 0;
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text('OK'),
                      onPressed: () {
                        if (nameOfPlace != null &&
                            nameOfPlace!.isNotEmpty &&
                            nameOfPlace!.length > 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Name should contain less than 10 characters'),
                            ),
                          );
                        } else {
                          if (nameOfPlace != null && nameOfPlace!.isNotEmpty) {
                            flag = 1;
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a Valid name'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            );
            if (flag == 1 && nameOfPlace != null && nameOfPlace!.isNotEmpty) {
              _getLocation().then(((value) {
                lat = '${value.latitude}';
                long = '${value.longitude}';
                addLocation(
                    nameOfPlace: nameOfPlace!, latitude: lat, longitude: long);
              }));
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text('Please enter a Valid name'),
              //     ),
              //   );
            }
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
      height: 120,
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
                current.nameOfPlace,
                style: GoogleFonts.overpass(fontSize: 20),
              ),
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
                    .collection('users')
                    .doc(uid)
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
      .collection('users')
      .doc(uid)
      .collection('Location')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => location.fromJson(doc.data())).toList());

  Future addLocation({
    required String nameOfPlace,
    required String latitude,
    required String longitude,
  }) async {
    final docLoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Location')
        .doc();
    final loc = location(
        id: docLoc.id,
        nameOfPlace: nameOfPlace,
        latitude: latitude,
        longitude: longitude);
    final json = loc.toJson();
    await docLoc.set(json);
  }
}

class location {
  late String id, nameOfPlace;
  final String latitude, longitude;
  location(
      {this.id = '',
      required this.latitude,
      required this.longitude,
      required this.nameOfPlace});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameOfPlace': nameOfPlace,
        'latitude': latitude,
        'longitude': longitude
      };
  static location fromJson(Map<String, dynamic> json) => location(
        id: json['id'],
        nameOfPlace: json['nameOfPlace'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
