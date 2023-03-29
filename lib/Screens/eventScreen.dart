import 'package:ark/Widgets/addEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TimeOfDay? time = const TimeOfDay(hour: 9, minute: 22);
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: w / 20, vertical: h / 40),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                child: Text("hello"),
              ),
              onTap: () {},
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.timer),
        onPressed: () async {
          TimeOfDay? newTime =
              await showTimePicker(context: context, initialTime: time!);
          if (newTime != null) {
            setState(() {
              time = newTime;
              createUser(
                  hours: time!.hour.toString(),
                  minutes: time!.minute.toString(),
                  am: time!.hourOfPeriod.toInt().isOdd);
            });
          }
        },
      ),
    );
  }

  Stream<List<Time>> readUsers() => FirebaseFirestore.instance
      .collection('time')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Time.fromJson(doc.data())).toList());

  Future createUser(
      {required String hours,
      required String minutes,
      required bool am}) async {
    final docUser = FirebaseFirestore.instance.collection('time').doc();
    final time = Time(id: docUser.id, hours: hours, am: am, minutes: minutes);
    final json = time.toJson();
    await docUser.set(json);
  }
}

class Time {
  late String id;
  final String hours, minutes;
  final bool am;
  Time(
      {this.id = '',
      required this.am,
      required this.hours,
      required this.minutes});

  Map<String, dynamic> toJson() => {
        'id': id,
        'hours': hours,
        'minutes': minutes,
        'am': am,
      };
  static Time fromJson(Map<String, dynamic> json) =>
      Time(am: json['am'], hours: json['hours'], minutes: json['minutes']);
}
