import 'dart:ui';

import 'package:ICE/directory.dart';
import 'package:ICE/filedownload.dart';
import 'package:ICE/indentations.dart';
import 'package:ICE/singlelines.dart';
import 'package:flutter/material.dart';
import 'package:ICE/javadocs.dart';
import 'package:ICE/whitespace.dart';
import 'package:flutter/services.dart';

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
String finalFileContent;

class MyOperationPage extends StatefulWidget {
  const MyOperationPage({Key key, this.file}) : super(key: key);
  final String file;

  static String getFileContents() {
    return finalFileContent;
  }

  @override
  _MyOperationPageState createState() => _MyOperationPageState();
}

class _MyOperationPageState extends State<MyOperationPage> {
  bool _javadoc = false;
  bool _singleComment = false;
  bool _whitespace = false;
  bool _indentation = false;
  Color _javadocIcon = lightCyan;
  Color _singleCommentIcon = lightCyan;
  Color _whitespaceIcon = lightCyan;
  Color _indentationIcon = lightCyan;
  double _javadocOpacity = 0.5;
  double _singleCommentOpacity = 0.5;
  double _whitespaceOpacity = 0.5;
  double _indentationOpacity = 0.5;
  Color _errorColor = lightCyan;

  void prevPage(BuildContext context) {
    Navigator.pop(context);
  }

  void nextPage(String result, BuildContext context) {
    finalFileContent = result;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => 
        MyFileDownloadPage(contents: finalFileContent,),
      ),
    );
  }

  void setJavadoc() {
    if (!_javadoc) {
      _javadoc = true;
      _javadocIcon = midCyan;
      _javadocOpacity = 1;
    } else {
      _javadoc = false;
      _javadocIcon = lightCyan;
      _javadocOpacity = 0.5;
    }
  }

  void setSingleLine() {
    if (!_singleComment) {
      _singleComment = true;
      _singleCommentIcon = midCyan;
      _singleCommentOpacity = 1;
    } else {
      _singleComment = false;
      _singleCommentIcon = lightCyan;
      _singleCommentOpacity = 0.5;
    }
  }

  void setWhitespaces() {
    if (!_whitespace) {
      _whitespace = true;
      _whitespaceIcon = midCyan;
      _whitespaceOpacity = 1;
    } else {
      _whitespace = false;
      _whitespaceIcon = lightCyan;
      _whitespaceOpacity = 0.5;
    }
  }

  void setIndentation() {
    if (!_indentation) {
      _indentation = true;
      _indentationIcon = midCyan;
      _indentationOpacity = 1;
    } else {
      _indentation = false;
      _indentationIcon = lightCyan;
      _indentationOpacity = 0.5;
    }
  }

  String runSoftware(String file, bool javdoc, bool comment, bool space, bool indent) {
    String contents = file;
    if (indent) {
      Indentations indents = new Indentations();
      contents = indents.main(contents);
    }
    if (comment) {
      SingleLineComments comments = new SingleLineComments();
      contents = comments.main(contents);
    }
    if (space) {
      Whitespace whitespace = new Whitespace();
      contents = whitespace.main(contents);
    }
    if (javdoc) {
      JavadocComments java = new JavadocComments();
      contents = java.main(contents);
    }
    return contents;
  }

  AnimatedOpacity getOpacityButton(var method, String buttonText, double opac, ) {
    return AnimatedOpacity(
      child: RaisedButton(
        onPressed: () {
          setState(() {
            method();
          });
        },
        color: midCyan,
        elevation: 0,
        focusElevation: 1.5,
        textColor: lightCyan,
        padding: EdgeInsets.only(left: 30, right: 32, top: 17, bottom: 17),
        clipBehavior: Clip.none,
        child: Container(
          child: Row(
            children: [
              Icon(
                Icons.code,
                color: lightCyan,
              ),
              Text(
                buttonText,
                style: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ), 
        ),
      ),
      duration: const Duration(milliseconds: 500),
      opacity: opac,
    );
  }

  Text getText(double size, String text, Color color, TextAlign t) {
    return Text(text,
      textAlign: t,
      style: TextStyle(
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w300,
        fontSize: size,
        color: color,
      ),
    );
  }

  Icon getIcon(Color iconCol) {
    return Icon(
      Icons.check,
      color: iconCol,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double blockSize = width / 100;
    AnimatedOpacity javadocButton = getOpacityButton(setJavadoc, '  Javadocs', _javadocOpacity);
    AnimatedOpacity singleLineButton = getOpacityButton(setSingleLine, '  // Comments', _singleCommentOpacity);
    AnimatedOpacity whitespaceButton = getOpacityButton(setWhitespaces, '  Whitespaces', _whitespaceOpacity); 
    AnimatedOpacity indentationButton = getOpacityButton(setIndentation, '  Indentations', _indentationOpacity);

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
                  getText(blockSize * 5.5, 'Choose an operation', midCyan, TextAlign.center),
                  getText(
                    blockSize * 1.5,
                    'Choose the operations you want to perform on the .java files.\nThe software will ' +
                    'only apply the selected operations on the contents\nof the .java file and you can download' +
                    ' the fixed version in the next step:\n\n',
                    darkCyan,
                    TextAlign.center
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          javadocButton,
                          getText(blockSize * 1.1, '\nAdds Missing\nJavadocs', darkCyan, TextAlign.center),
                          Text(''),
                          getIcon(_javadocIcon),
                        ],
                      ),
                      Text('\t\t'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          singleLineButton,
                          getText(blockSize * 1.1, '\nRemoves Single\nLine Comments', darkCyan, TextAlign.center),
                          Text(''),
                          getIcon(_singleCommentIcon),
                        ],
                      ),
                      Text('\t\t'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          whitespaceButton,
                          getText(blockSize * 1.1, '\nFixes Incorrect\nWhitespaces', darkCyan, TextAlign.center),
                          Text(''),
                          getIcon(_whitespaceIcon),
                        ],
                      ),
                      Text('\t\t'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          indentationButton,
                          getText(blockSize * 1.1, '\nFixes Incorrect\nIndentations', darkCyan, TextAlign.center),
                          Text(''),
                          getIcon(_indentationIcon),
                        ],
                      ),
                    ],
                  ),
                  Text('\n\n'),
                  RaisedButton(
                    onPressed: () {
                      if (!_javadoc && !_singleComment && !_indentation && !_whitespace) {
                        setState(() {
                          _errorColor = Colors.red;
                        });
                      } else {
                        _errorColor = lightCyan;
                        String result = "";
                        result = runSoftware(MyDirectoryPage.getFileContents(), _javadoc, _singleComment, _whitespace, _indentation);
                        nextPage(result, context);
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
                      child: getText (blockSize * 1.4, 'Run', lightCyan, TextAlign.center),
                    ),
                  ),
                  Text(
                    '\n\n* Please select at least one operation',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w300,
                      color: _errorColor,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton (
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward_ios),
                    color: lightCyan,
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