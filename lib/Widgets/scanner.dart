import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';

class FileScanner extends StatefulWidget {
  const FileScanner({super.key});

  @override
  State<FileScanner> createState() => _FileScannerState();
}

class _FileScannerState extends State<FileScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (() async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                print('28');
                if (result != null) {
                  print('30');
                  File file = File(result.files.single.path!);
                  print('32');
                  PDFDoc doc = await PDFDoc.fromFile(file);
                  print('34');
                } else {}
              }),
              child: Text("scan!.!"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
    ;
  }
}
