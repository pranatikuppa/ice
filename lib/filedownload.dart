import 'dart:convert';
import 'dart:ui';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:ICE/operation.dart';
import 'package:ICE/directory.dart';

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
String fileContents = "";
TextEditingController textController = new TextEditingController();
String filename = "";

class MyFileDownloadPage extends StatefulWidget {
  MyFileDownloadPage({Key key, this.contents}) : super(key:key);
  final String contents;

  @override
  _MyFileDownloadPageState createState() => _MyFileDownloadPageState();
}

class _MyFileDownloadPageState extends State<MyFileDownloadPage> {
 
  String cleanFilename(String name) {
    if (name == "") {
      return "File1.java";
    } else if (!name.contains(".") && !name.contains(".java")) {
      return name + ".java";
    } else if (name.contains(".")) {
      int dotIndex = name.indexOf(".", 0);
      return name.substring(0, dotIndex) + ".java";
    } else {
      return name;
    }
  }

  void mainInfoPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void chooseFilePage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => 
        MyDirectoryPage(),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text(
                'Download your file',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w300,
                  fontSize: blockSize * 5.5,
                  color: midCyan,
                ),
              ),
              Text(
                'Type in the name you want for the file (ex. filename.java) and then click "Download File."\n' +
                'If you do not enter a name for the file we will give it a generic name:\n\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w300,
                  fontSize: blockSize * 1.5,
                  color: darkCyan,
                ),
              ),
              Container(
                width: 450,
                height: 60,
                child: TextField(
                  onChanged: (String t) {
                    filename = t;
                  },
                  controller: textController,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: darkCyan,
                    fontFamily: "Open Sans",
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: midCyan,
                        width: 1.0,
                      ),
                    ),
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: midCyan,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Text("\n\n"),
              RaisedButton(
                onPressed: () async {
                  filename = cleanFilename(textController.text);
                  final text = MyOperationPage.getFileContents();
                  final bytes = utf8.encode(text);
                  final blob = html.Blob([bytes]);
                  js.context.callMethod("webSaveAs", [blob, filename]);
                },
                color: midCyan,
                elevation: 0,
                focusElevation: 1.5,
                disabledColor: darkCyan,
                textColor: lightCyan,
                padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                clipBehavior: Clip.none,
                child: Container(
                  child: const Text(
                    'Download File',
                    style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Text("\n\n"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      chooseFilePage(context);
                    },
                    color: midCyan,
                    elevation: 0,
                    focusElevation: 1.5,
                    disabledColor: darkCyan,
                    textColor: lightCyan,
                    padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    clipBehavior: Clip.none,
                    child: Container(
                      child: const Text(
                        'Choose New File',
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  Text("\t\t"),
                  RaisedButton(
                    onPressed: () {
                      mainInfoPage(context);
                    },
                    color: midCyan,
                    elevation: 0,
                    focusElevation: 1.5,
                    disabledColor: darkCyan,
                    textColor: lightCyan,
                    padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    clipBehavior: Clip.none,
                    child: Container(
                      child: const Text(
                        'Go To Main Page',
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
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