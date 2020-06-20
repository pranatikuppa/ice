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
  final PageController controller;
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

  /*
   * Method that uses the HTML plugin to 
   * open the upload dialog on the device. 
   */
  uploadFiles(double errorSize, double filenameSize) async {
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
              _displayText = getText(filenameSize, _fileName, darkCyan);
              _iconColor = midCyan;
              _validFileChosen = true;
            }
          });
        });
        reader.onError.listen((event) {
          setState(() {
            _iconColor = lightCyan;
            _displayText = getErrorText(errorSize);
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

  Text getErrorText(double tSize) {
    return Text(
      '* Please select a file (.java file)',
      style: TextStyle(
        color: Colors.red,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w300,
        fontSize: tSize,
      ),
    );
  }

  /*
   * Changes the state of the page by moving to the next page.
   * Scrolls down with the scroll controller and passes along 
   * user data to the next page.
   */
  void nextPage() {
    widget.controller.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
    /* Measurements used to resize elements based on window size. */
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scale = (width * height) / 10000;

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
              getText(scale * 0.696, 'Choose a file', midCyan),
              getText(
                scale * 0.174,
                'Upload a file (.java file) you would like the program to clear\nstyle check errors:\n\n',
                darkCyan
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                width: scale * 3.92,
                height: scale * 0.522,
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
                  uploadFiles(scale * 0.147, scale * 0.147);
                },
                color: midCyan,
                textColor: lightCyan,
                elevation: 0,
                padding: EdgeInsets.only(left: scale * 0.261, right: scale * 0.261, top: scale * 0.131, bottom: scale * 0.131),
                focusElevation: 2.0,
                child: getText(scale * 0.157, 'Upload File', lightCyan),
              ),
              Text('\n\n'),
              RaisedButton(
                onPressed: () {
                  validateFile();
                  if (!_validFileChosen) {
                    setState(() {
                      _displayText = getErrorText(scale * 0.147);
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
                padding: EdgeInsets.only(left: scale * 0.261, right: scale * 0.261, top: scale * 0.131, bottom: scale * 0.131),
                focusElevation: 2.0,
                child: getText(scale * 0.157, 'Continue', lightCyan),
              ),
            ],
          ),
        ],
      ),
    );
  }
}