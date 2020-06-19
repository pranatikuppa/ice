import 'dart:convert';
import 'dart:ui';
import 'dart:html';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:ICE/operation.dart';
import 'package:ICE/directory.dart';
import 'main.dart';

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

/* The file download page section where users can download the fixed java files. */
class MyFileDownloadPage extends StatefulWidget {
  MyFileDownloadPage({Key key, this.homepage, this.controller, this.contents, this.disabled, this.listener}) : super(key:key);

  /* Instances variables of the file download page section. */
  final String contents;
  final ScrollController controller;
  MyDirectoryPage pageRef1;
  MyHomePage pageRef2;
  bool disabled;
  String finalFixedFileContents;
  var listener;
  final MyHomePage homepage;

  /*
   * Sets the first page reference of the file download page section. 
   */
  void setPageRef1(StatefulWidget page1) {
    pageRef1 = page1;
  }

  /*
   * Sets the second page reference of the file download page section. 
   */
  void setPageRef2(StatefulWidget page2) {
    pageRef2 = page2;
  }

  /*
   * Sets the final file contents to the corresponding instance variable.
   */
  void setFixedFileContents(String fixedContent) {
    finalFixedFileContents = fixedContent;
  }

  /*
   * Resets all the variables of the file download page section. 
   */
  void resetAll() {

  }

  /*
   * Sets the listener of this section to the function list.  
   */
  void setListener(void Function() list) {
    listener = list;
  }

  @override
  _MyFileDownloadPageState createState() => _MyFileDownloadPageState();
}

/* The state of the file download page section. */
class _MyFileDownloadPageState extends State<MyFileDownloadPage> {

  /* Variables that control the state of the file download page section. */
  TextEditingController _textController = new TextEditingController();
  String _filename = "";

  /*
   * Takes in a name of a potential file and cleans the name
   * based on spaces, extensions, etc. Only outputs the format
   * of filename.java. 
   */
  String cleanFilename(String name) {
    name = name.replaceAll(" ", "_");
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

  /*
   * Downloads the file to the device.  
   */
  void downloadFile() {
    setState(() {
        widget.pageRef1.nextPage.disabled = false;
        widget.disabled = false;
    });
    if (!widget.disabled) {
      _filename = cleanFilename(_textController.text);
      final text = widget.finalFixedFileContents;
      final bytes = utf8.encode(text);
      final blob = Blob([bytes]);
      js.context.callMethod("webSaveAs", [blob, _filename]);
      widget.controller.animateTo(2310, duration: Duration(milliseconds: 100), curve: Curves.ease);
    }
  }

  /*
   * Sets the state of the page by scrolling up
   * to the main info page. Sets the other pages to be disabled.
   */
  void mainInfoPage() {
    // if (!widget.disabled) {
      setState(() {
        widget.pageRef1.nextPage.disabled = true;
        widget.disabled = true;
      });
      widget.controller.jumpTo(3);
    // }
  }

  /*
   * Sets the state of the page by scrolling up 
   * to the choose file page section. Sets the 
   * later pages to be disabled.
   */
  void chooseFilePage() {
    // if (!widget.disabled) {
      setState(() {
        widget.pageRef1.nextPage.disabled = true;
        widget.disabled = true;
      });
      widget.controller.jumpTo(750);
    // }
  }

  /*
   * Helper method that returns a text widget based on
   * size, text and color. Assumes that the text is center 
   * aligned. 
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

  /*
   * Helper method that returns a raised button based on the 
   * method to be called upon on pressed, the button text and 
   * the size of the button.  
   */
  RaisedButton getButton(var method, String buttonText, double size) {
    return RaisedButton(
      onPressed: () {
        if (!widget.disabled) {
          method();
        }
      },
      color: midCyan,
      elevation: 0,
      focusElevation: 1.5,
      disabledColor: lightCyan,
      textColor: Colors.white,
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      clipBehavior: Clip.none,
      child: Container(
        child: Text(
          buttonText,
          style: TextStyle(
            fontFamily: "Open Sans",
            fontSize: size,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* The container widget that displays all the UI elements of the page section. */
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          getText(80, 'Download your file', midCyan),
          getText(
            20,
            'Type in the name you want for the file (ex. filename.java) and then click "Download File."\n' +
            'If you do not enter a name for the file we will give it a generic name:\n\n',
            darkCyan,
          ),
          Container(
            width: 450,
            height: 60,
            child: TextField(
              onChanged: (String t) {
                _filename = t;
              },
              controller: _textController,
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
              if (!widget.disabled) {
                downloadFile();
              }
            },
            color: midCyan,
            elevation: 0,
            focusElevation: 1.5,
            disabledColor: darkCyan,
            textColor: lightCyan,
            padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
            clipBehavior: Clip.none,
            child: Container(
              child: Text(
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
              getButton(chooseFilePage, 'Choose New File', 18),
              Text("\t\t"),
              getButton(mainInfoPage, 'Go To Main Page', 18),
            ],
          ),
        ],
      ),
    );
  }
}