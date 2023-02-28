import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePick extends StatefulWidget {
  const FilePick({super.key});

  @override
  State<FilePick> createState() => _FilePickState();
}

class _FilePickState extends State<FilePick> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
        w = MediaQuery.of(context).size.width;
    return Container(
      height: h / 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: w / 10),
      decoration: BoxDecoration(color: Colors.red),
      child: GestureDetector(onTap: (() {})),
    );
  }
}
