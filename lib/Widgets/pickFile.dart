// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
// import '../constants.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FilePick extends StatefulWidget {
//   const FilePick({super.key});

//   @override
//   State<FilePick> createState() => _FilePickState();
// }

// class _FilePickState extends State<FilePick> {
//   @override
//   Widget build(BuildContext context) {
//     double h = MediaQuery.of(context).size.height,
//         w = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       child: Container(
//           margin: EdgeInsets.symmetric(horizontal: w / 20, vertical: h / 40),
//           height: h / 15,
//           width: w / 2,
//           decoration: BoxDecoration(
//               color: Colors.blue, borderRadius: BorderRadius.circular(10)),
//           child: Center(
//             child: Text(
//               "Upload Doc",
//               style: GoogleFonts.openSans(
//                   color: white, fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//           )),
//       onTap: (() async {
//         FilePickerResult? result = await FilePicker.platform.pickFiles();

//         if (result != null) {
//           File file = File(result.files.single.path!);
//         } else {}
//       }),
//     );
//   }
// }
