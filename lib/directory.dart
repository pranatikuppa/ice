import 'dart:html';
import 'dart:ui';
import 'package:ICE/main.dart';
import 'package:flutter/material.dart';
import 'package:ICE/operation.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

Map<int, Color> cyanColorCodes = {
    50: Color.fromRGBO(21, 72, 84, 0.1),
    100: Color.fromRGBO(21, 72, 84, 0.2),
    200: Color.fromRGBO(21, 72, 84, 0.3),
    300: Color.fromRGBO(21, 72, 84, 0.4),
    400: Color.fromRGBO(21, 72, 84, 0.5),
    500: Color.fromRGBO(21, 72, 84, 0.6),
    600: Color.fromRGBO(21, 72, 84, 0.7),
    700: Color.fromRGBO(21, 72, 84, 0.8),
    800: Color.fromRGBO(21, 72, 84, 0.9),
    900: Color.fromRGBO(21, 72, 84, 1)
  };

MaterialColor darkCyan = MaterialColor(0xFF154854, cyanColorCodes);
MaterialColor midCyan = MaterialColor(0xFF6493a1, cyanColorCodes);
MaterialColor lightCyan = MaterialColor(0xFFe3ecef, cyanColorCodes);
String finalString;

class MyDirectoryPage extends StatefulWidget {
  MyDirectoryPage({Key key, this.title}) : super(key:key);
  final String title;

  static String getFileContents() {
    return finalString;
  }

  @override
  _MyDirectoryPageState createState() => _MyDirectoryPageState();
}

class _MyDirectoryPageState extends State<MyDirectoryPage> {
  final directoryTextController = new TextEditingController();
  FilePickerCross filePicker = FilePickerCross();
  String _fileString = "";
  bool _validFileChosen = false;
  Text _displayText = Text('');
  Color _iconColor = lightCyan;
  String _fileName = "";
  Text _errorText = Text(
      '* Please select a file (.java file)',
      style: TextStyle(
        color: Colors.red,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w300,
      ),
    );

  uploadFiles() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.accept = ".java";
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        final reader = FileReader();
        reader.onLoadEnd.listen((event) {
          String _stringData = reader.result.toString();
          setState(() {
            _fileString = _stringData;
            _fileName = file.name;
            if (_fileString.isNotEmpty) {
              _displayText = Text(
                _fileName,
                style: TextStyle(
                  color: darkCyan,
                  fontFamily: "Open Sans",
                  fontWeight: FontWeight.w300,
                ),
              );
              _iconColor = midCyan;
              _validFileChosen = true;
            }
          });
        });
        reader.onError.listen((event) {
          setState(() {
            _iconColor = lightCyan;
            _displayText = _errorText;
            _validFileChosen = false;
          });
        });
        reader.readAsText(file);
      }
    });
  }

  void validateFile() {
    if (_fileString.isEmpty) {
      _validFileChosen = false;
    }
  }

  void nextPage(BuildContext context) {
    finalString = _fileString;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => 
        MyOperationPage(file: _fileString,),
      ),
    );
  }

  void prevPage(BuildContext context) {
    Navigator.pop(context);
  }

  void saveFileContents(String path) {
    finalString = path;
  }

  Text getText(double size, String text, Color color) {
    return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w300,
        fontSize: size,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double blockSize = width / 100;

    return Scaffold(
      body: Center(
        child: Container(
          color: lightCyan,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton (
                    onPressed: () {prevPage(context);}, 
                    icon: Icon(Icons.arrow_back_ios),
                    color: midCyan,
                    iconSize: blockSize * 4,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getText(blockSize * 6, 'Choose a file', midCyan),
                  getText(
                    blockSize * 1.5,
                    'Upload a file (.java file) you would like the program to clear\nstyle check errors:\n\n',
                    darkCyan
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: 450,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: midCyan,
                        width: 1.0
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: _iconColor, 
                        ),
                        Text("  "),
                        _displayText,
                      ],
                    ),
                  ),
                  Text('\n\n\n\n'),
                  RaisedButton(
                    onPressed: () {uploadFiles();},
                    color: midCyan,
                    textColor: lightCyan,
                    elevation: 0,
                    padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    focusElevation: 2.0,
                    child: getText(blockSize * 1.4, 'Upload File', lightCyan),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton (
                    onPressed: () {
                      validateFile();
                      setState(() {
                        if (!_validFileChosen) {
                          _displayText = _errorText;
                        } else {
                          saveFileContents(_fileString);
                          nextPage(context);
                        }
                      });
                    }, 
                    icon: Icon(Icons.arrow_forward_ios),
                    color: midCyan,
                    iconSize: blockSize * 4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}