// import 'package:ark/Login/forgotPassword.dart';
// import 'package:ark/Screens/myLocations.dart';
// import 'package:ark/Screens/profile.dart';
// import 'package:ark/Widgets/eventButton.dart';
// import 'package:ark/Widgets/location.dart';
// import 'package:ark/Login/logIn.dart';
// import 'package:ark/Widgets/pickFile.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sound_mode/permission_handler.dart';
// import 'package:sound_mode/sound_mode.dart';
// import 'package:sound_mode/utils/ringer_mode_statuses.dart';

// import '../constants.dart';
// import 'package:flutter/material.dart';
// import 'textExtracter.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:pdf_render/pdf_render.dart';

// // Future<String?> _extractText() async {
// //   final result = await FilePicker.platform.pickFiles(
// //     type: FileType.custom,
// //     allowedExtensions: ['pdf'],
// //   );

// //   if (result == null) {
// //     // User cancelled the picker
// //     return null;
// //   }

// //   final file = File(result.files.single.path!);
// //   final doc = await PdfDocument.openFile(file.path);
// //   final pageCount = doc.pageCount;
// //   String text = "";

// //   for (int i = 0; i < pageCount; i++) {
// //     final page = await doc.getPage(i + 1);
// //     final pageText = page.toString();
// //     text += pageText;
// //     // await page.close();
// //   }

// //   return text;
// // }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   late final files, path, file, fileText = "hello";
//   TextEditingController txt = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     // final Future<String?> s = _extractText();
//     return Scaffold(
//       drawer: Drawer(
//           child: ListView(children: [
//         ListTile(
//           tileColor: white,
//           title: Center(child: Text('Account')),
//           onTap: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => profile()));
//           },
//         ),
//         ListTile(
//           tileColor: white,
//           title: Center(child: Text('Change Password')),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => ForgotPassword()));
//           },
//         ),
//         ListTile(
//           tileColor: white,
//           title: Center(child: Text('Change to normal mode')),
//           onTap: () async {
//             bool? isGranted = await PermissionHandler.permissionsGranted;
//             print(SoundMode.ringerModeStatus);
//             print("hello");
//             if (!isGranted!) {
//               // Opens the Do Not Disturb Access settings to grant the access
//               await PermissionHandler.openDoNotDisturbSetting();
//             } else {
//               try {
//                 await SoundMode.setSoundMode(RingerModeStatus.normal);
//               } on PlatformException {
//                 print('Please enable permissions required');
//               }
//             }
//           },
//         ),
//         ListTile(
//           tileColor: white,
//           title: Center(child: Text('Location')),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => MyLocations()));
//           },
//         ),
//       ])),
//       appBar: AppBar(
//           centerTitle: true,
//           title: (Text(
//             "Hello There...!",
//             style: GoogleFonts.sourceSansPro(
//                 fontSize: 22, fontWeight: FontWeight.w500),
//           )),
//           actions: [
//             IconButton(
//                 onPressed: () async {
//                   await FirebaseAuth.instance.signOut();
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (context) => LogIn()),
//                     (Route<dynamic> route) => false,
//                   );
//                 },
//                 icon: Icon(Icons.logout))
//           ]),
//       body: Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Location(),
//               FilePick(),
//               EventButton(),
//               GestureDetector(
//                   onTap: (() {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => FlutterDemo(
//                                   storage: CounterStorage(),
//                                 )));
//                   }),
//                   child: TextButton(
//                       onPressed: () {
//                         print('read succesfully');
//                         setState(() async {
//                           FilePickerResult? result = await FilePicker.platform
//                               .pickFiles(allowMultiple: false);

//                           if (result == null) {
//                             return;
//                           }
//                           files = result.files;
//                           path = files.first.path.toString();
//                           file = File(path);
//                           final fileText = await file.readAsString();
//                           txt.text = fileText;
//                           // print(fileText);
//                         });
//                       },
//                       child: Text('read'))
//                   // Text('s.toString()'),
//                   )
//               // _extractText();
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
