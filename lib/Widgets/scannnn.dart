import 'dart:math';
import 'package:ark/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pdf_text/pdf_text.dart';

class ScanPdf extends StatefulWidget {
  const ScanPdf({super.key});

  @override
  State<ScanPdf> createState() => _ScanPdfState();
}

class _ScanPdfState extends State<ScanPdf> {
  PDFDoc? _pdfDoc;
  String _text = "";

  bool _buttonsEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('PDF Text Example'),
            centerTitle: true,
            backgroundColor: maincolour,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                TextButton(
                  child: Text(
                    "Pick PDF document",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(5), backgroundColor: maincolour),
                  onPressed: _pickPDFText,
                ),
                TextButton(
                  child: Text(
                    "Read random page",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(5), backgroundColor: maincolour),
                  onPressed: _buttonsEnabled ? _readRandomPage : () {},
                ),
                TextButton(
                  child: Text(
                    "Read whole document",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(5), backgroundColor: maincolour),
                  onPressed: _buttonsEnabled
                      ? _readWholeDoc
                      : () {
                          SnackBar(
                            content: Text("No file picked!"),
                            backgroundColor: Colors.red,
                          );
                        },
                ),
                Padding(
                  child: Text(
                    _pdfDoc == null
                        ? "Pick a new PDF document and wait for it to load..."
                        : "PDF document loaded, ${_pdfDoc!.length} pages\n",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(15),
                ),
                Padding(
                  child: Text(
                    _text == "" ? "" : "Text:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(15),
                ),
                Text(_text),
              ],
            ),
          )),
    );
  }

  /// Picks a new PDF document from the device
  Future _pickPDFText() async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
      setState(() {});
    }
  }

  /// Reads a random page of the document
  Future _readRandomPage() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text =
        await _pdfDoc!.pageAt(Random().nextInt(_pdfDoc!.length) + 1).text;

    setState(() {
      _text = text;
      _buttonsEnabled = true;
    });
  }

  /// Reads the whole document
  Future _readWholeDoc() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text = await _pdfDoc!.text;
    int size = text.length, flag = 1, len = 0, found = 0, j;
    print("size");
    print(size);
    for (int i = 0; i < size - 10; i++) {
      len = 0;
      flag = 1;
      for (j = i; j < i + 10 && flag == 1; j++) {
        if ((j - i == 2 || j - i == 5)) {
          if (text[i] != '-') {
            flag = 0;
          } else {
            len++;
          }
        } else {
          if (text[i] == '0' ||
              text[i] == '1' ||
              text[i] == '2' ||
              text[i] == '3' ||
              text[i] == '4' ||
              text[i] == '5' ||
              text[i] == '6' ||
              text[i] == '7' ||
              text[i] == '8' ||
              text[i] == '9') {
            len++;
          } else {
            flag = 0;
          }
        }
      }
      if (len == 10) {
        found++;
        print("${text.substring(j, j + 10)}");
      }
      print("len: " + len.toString());
    }
    if (found == 0) {
      print("No date found");
    }
    setState(() {
      _text = text;
      _buttonsEnabled = true;
    });
  }
}
