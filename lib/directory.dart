import 'dart:html';
import 'dart:ui';
import 'package:ICE/main.dart';
import 'package:flutter/material.dart';
import 'package:ICE/operation.dart';

/* The cyan color codes that are used in the them of this application. */
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

/* Three variations of the cyan color codes used throughout the application. */
MaterialColor darkCyan = MaterialColor(0xFF154854, cyanColorCodes);
MaterialColor midCyan = MaterialColor(0xFF6493a1, cyanColorCodes);
MaterialColor lightCyan = MaterialColor(0xFFe3ecef, cyanColorCodes);

/* File page section where users can choose which java file to upload for style fixes. */
class MyDirectoryPage extends StatefulWidget {
  MyDirectoryPage({Key key, this.homepage, this.controller, this.nextPage, this.listener}) : super(key:key);

  /* Instance variables of the file page section. */
  final ScrollController controller;
  final MyOperationPage nextPage;
  final MyHomePage homepage;
  var listener;

  /* Resets all the variables of this page. */
  void resetAll() {

  }

  /* Sets the listener of the page to the given function list. */
  void setListener(void Function() list) {
    listener = list;
  }

  @override
  _MyDirectoryPageState createState() => _MyDirectoryPageState();
}

/* State of the Choose file page. */
class _MyDirectoryPageState extends State<MyDirectoryPage> {
  /* Variables that are needed to track the state of the page. */
  String _fileString = "";
  bool _validFileChosen = false;
  Text _displayText = Text('');
  Color _iconColor = Colors.white;
  String _fileName = "";
  Text _errorText = Text(
      '* Please select a file (.java file)',
      style: TextStyle(
        color: Colors.red,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w300,
      ),
    );

  /*
   * Method that uses the HTML plugin to 
   * open the upload dialog on the device. 
   */
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

  /*
   * If the file string is not empty then
   * validates the file. 
   */
  void validateFile() {
    if (_fileString.isEmpty) {
      _validFileChosen = false;
    }
  }

  /*
   * Changes the state of the page by moving to the next page.
   * Scrolls down with the scroll controller and passes along 
   * user data to the next page.
   */
  void nextPage() {
    widget.controller.animateTo(1500, duration: Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {
      widget.nextPage.setFileContents(_fileString);
    });
  }

  /*
   * Saves the file contents provided in the state of the page. 
   */
  void saveFileContents(String contents) {
    _fileString = contents;
  }

  /*
   * Helper method that returns a text widget based on
   * size, text and color. Assumes that the alignment will be 
   * centered.
   */
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
    /* The container widget that contains the UI elements of this page section. */
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getText(80, 'Choose a file', midCyan),
              getText(
                20,
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
              Text('\n\n'),
              RaisedButton(
                onPressed: () {
                  uploadFiles();
                },
                color: midCyan,
                textColor: lightCyan,
                elevation: 0,
                padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                focusElevation: 2.0,
                child: getText(18, 'Upload File', lightCyan),
              ),
              Text('\n\n'),
              RaisedButton(
                onPressed: () {
                  validateFile();
                  if (!_validFileChosen) {
                    setState(() {
                      _displayText = _errorText;
                    });
                  } else {
                    setState(() {
                      saveFileContents(_fileString);
                      widget.nextPage.disabled = false;
                    });
                    nextPage();
                  }
                },
                color: midCyan,
                textColor: lightCyan,
                elevation: 0,
                padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                focusElevation: 2.0,
                child: getText(18, 'Continue', lightCyan),
              ),
            ],
          ),
        ],
      ),
    );
  }
}