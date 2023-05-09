import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:ark/Screens/profile.dart';
import 'package:ark/Widgets/addEvent.dart';
import 'package:ark/constants.dart';
import 'package:ark/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

import '../Login/forgotPassword.dart';
import 'myLocations.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({
    super.key,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  TimeOfDay? timeOfDay = const TimeOfDay(hour: 9, minute: 22);
  int alarmID = 1;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
          child: ListView(children: [
        ListTile(
          tileColor: white,
          title: Center(child: Text('Account')),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => profile()));
          },
        ),
        ListTile(
          tileColor: white,
          title: Center(child: Text('Change Password')),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForgotPassword()));
          },
        ),
        ListTile(
          tileColor: white,
          title: Center(child: Text('Change to normal mode')),
          onTap: () async {
            bool? isGranted = await PermissionHandler.permissionsGranted;
            print(SoundMode.ringerModeStatus);
            print("hello");
            if (!isGranted!) {
              // Opens the Do Not Disturb Access settings to grant the access
              await PermissionHandler.openDoNotDisturbSetting();
            } else {
              try {
                await SoundMode.setSoundMode(RingerModeStatus.normal);
              } on PlatformException {
                print('Please enable permissions required');
              }
            }
          },
        ),
        ListTile(
          tileColor: white,
          title: Center(child: Text('Location')),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyLocations()));
          },
        ),
      ])),
      appBar: AppBar(
        title: Text(
          "Current Events",
          style: GoogleFonts.sourceSansPro(
              fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
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
            String description = '';
            DateTime alarm = DateTime(2023);
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

              // Show dialog to get the description input
              String? description;

              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Enter a description'),
                    content: TextField(
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('OK'),
                        onPressed: () {
                          if (description != null && description!.isNotEmpty) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  );
                },
              );

              if (description != null && description!.isNotEmpty) {
                // Show date picker to pick a date
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (selectedDate != null) {
                  // Show time picker to pick a time
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    timeOfDay = selectedTime;
                    int y = selectedDate.year,
                        m = selectedDate.month,
                        d = selectedDate.day,
                        h = timeOfDay!.hour,
                        mi = timeOfDay!.minute;
                    createAlarm(
                      description: description!,
                      date: selectedDate.day.toString(),
                      month: selectedDate.month.toString(),
                      year: selectedDate.year.toString(),
                      hours: timeOfDay!.hour.toString(),
                      minutes: timeOfDay!.minute.toString(),
                    );
                    alarm = DateTime(y, m, d, h, mi, 0);

                    AndroidAlarmManager.oneShotAt(alarm, alarmID, fireAlarm);
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a description'),
                  ),
                );
              }
            });
          }),
    );
  }

  Widget buildTime(Time time) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: white,
          boxShadow: blueShadow,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: GestureDetector(
              onTap: () async {
                TextEditingController _descriptionController =
                    TextEditingController();
                DateTime _selectedDate = DateTime.now();
                TimeOfDay _selectedTime = TimeOfDay.now();

                // Set the initial values of the fields
                _descriptionController.text = time.description;
                _selectedDate = DateTime(int.parse(time.year),
                    int.parse(time.month), int.parse(time.date));
                _selectedTime = TimeOfDay(
                    hour: int.parse(time.hours),
                    minute: int.parse(time.minutes));

                // Show the dialog to edit the fields
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Edit Time',
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 24, color: pink),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: GoogleFonts.sourceSansPro(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 16),
                            ListTile(
                              title: Text(
                                'Date',
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _selectedDate = pickedDate;
                                  });
                                }
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Time',
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              subtitle:
                                  Text('${_selectedTime.format(context)}'),
                              onTap: () async {
                                final TimeOfDay? pickedTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTime,
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    _selectedTime = pickedTime;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 16, color: maincolour),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Update the time with the edited values
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .collection('time')
                                .doc(time.id)
                                .update({
                              'description': _descriptionController.text,
                              'year': _selectedDate.year.toString(),
                              'month': _selectedDate.month.toString(),
                              'date': _selectedDate.day.toString(),
                              'hours': _selectedTime.hour.toString(),
                              'minutes': _selectedTime.minute.toString(),
                            });

                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 16,
                                color: pink,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  },
                );
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
                      .collection('users')
                      .doc(userId)
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
      .collection('users')
      .doc(userId)
      .collection('time')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Time.fromJson(doc.data())).toList());

  Future createAlarm({
    required String hours,
    required String minutes,
    required String description,
    required String date,
    required String month,
    required String year,
  }) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('time')
        .doc();
    final time = Time(
        id: docUser.id,
        hours: hours,
        date: date,
        minutes: minutes,
        description: description,
        month: month,
        year: year);
    // , label: label);
    final json = time.toJson();
    await docUser.set(json);
  }
}

class Time {
  late String id;
  final String hours, minutes;
  final String date, month, year;
  final String description;
  Time(
      {this.id = '',
      required this.description,
      required this.date,
      required this.month,
      required this.year,
      required this.hours,
      required this.minutes});

  Map<String, dynamic> toJson() => {
        'id': id,
        'hours': hours,
        'minutes': minutes,
        'date': date,
        'month': month,
        'year': year,
        'description': description
      };
  static Time fromJson(Map<String, dynamic> json) => Time(
        id: json['id'],
        hours: json['hours'],
        minutes: json['minutes'],
        date: json['date'],
        month: json['month'],
        year: json['year'],
        description: json['description'],
      );
}

void fireAlarm() {
  print("Alarm");
}
