import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:ark/Widgets/addEvent.dart';
import 'package:ark/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TimeOfDay? timeOfDay = const TimeOfDay(hour: 9, minute: 22);
  int alarmID = 1;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: StreamBuilder<List<Time>>(
              stream: readUsers(),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final times = snapshot.data!;
                  return ListView(
                    children: times.map(buildTime).toList(),
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
        child: Icon(Icons.timer),
        onPressed: () async {
          TimeOfDay? newTime =
              await showTimePicker(context: context, initialTime: timeOfDay!);
          DateTime alarm = DateTime(2023);
          if (newTime != null) {
            setState(() async {
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
              timeOfDay = newTime;
              int y = 2023,
                  m = 4,
                  d = 2,
                  h = timeOfDay!.hour,
                  mi = timeOfDay!.minute;
              createAlarm(
                  // label: label,
                  hours: timeOfDay!.hour.toString(),
                  minutes: timeOfDay!.minute.toString(),
                  am: timeOfDay!.hourOfPeriod.toInt().isOdd);
              alarm = DateTime(y, m, d, h, mi, 0);
            });
            AndroidAlarmManager.oneShotAt(alarm, alarmID, fireAlarm);
          }
        },
      ),
    );
  }

  Widget buildTime(Time time) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: white,
          boxShadow: blueShadow,
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: GestureDetector(
              onTap: () async {
                TimeOfDay showtime = TimeOfDay(
                    hour: int.parse(time.hours),
                    minute: int.parse(time.minutes));
                TimeOfDay? newTime = await showTimePicker(
                    context: context, initialTime: showtime!);
                if (newTime != null) {
                  showtime = newTime;
                  setState(() async {
                    await FirebaseFirestore.instance
                        .collection('time')
                        .doc(time.id)
                        .update({
                      // 'id': time.id,
                      'hours': showtime.hour.toString(),
                      'minutes': showtime.minute.toString(),
                      'am': showtime.hourOfPeriod.toInt().isOdd,
                    });
                  });
                }
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      time.hours.padLeft(2, '0') +
                          " : " +
                          // ((((int.tryParse(time.minutes))!/10)=0)?'0':'' )+
                          time.minutes.padLeft(2, '0'),
                      // +(time.am ? " am" : " pm"),
                      style: GoogleFonts.lato(
                          fontSize: 20, fontWeight: FontWeight.w800),
                    )),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
                iconSize: 25,
                onPressed: () {
                  // print('object');
                  // setState(() async {
                  final doc = FirebaseFirestore.instance
                      .collection('time')
                      .doc(time.id);
                  doc.delete();
                  // });
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                )),
          )
        ],
      ),
    );
  }

  Stream<List<Time>> readUsers() => FirebaseFirestore.instance
      .collection('time')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Time.fromJson(doc.data())).toList());

  Future createAlarm(
      {required String hours,
      // required String label,
      required String minutes,
      required bool am}) async {
    final docUser = FirebaseFirestore.instance.collection('time').doc();
    final time = Time(id: docUser.id, hours: hours, am: am, minutes: minutes);
    // , label: label);
    final json = time.toJson();
    await docUser.set(json);
  }
}

class Time {
  late String id;
  final String hours, minutes;
  // label;
  final bool am;
  Time(
      {this.id = '',
      required this.am,
      // required this.label,
      required this.hours,
      required this.minutes});

  Map<String, dynamic> toJson() => {
        'id': id, 'hours': hours, 'minutes': minutes, 'am': am
        // , 'label': label
      };
  static Time fromJson(Map<String, dynamic> json) => Time(
        id: json['id'],
        am: json['am'],
        hours: json['hours'],
        minutes: json['minutes'],
      );
}

void fireAlarm() {
  print("Alarm");
}
