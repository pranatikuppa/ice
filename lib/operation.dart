import 'dart:ui';

import 'package:ICE/directory.dart';
import 'package:ICE/filedownload.dart';
import 'package:ICE/indentations.dart';
import 'package:ICE/singlelines.dart';
import 'package:flutter/material.dart';
import 'package:ICE/javadocs.dart';
import 'package:ICE/whitespace.dart';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double blockSize = width / 100;
    // FloatingActionButton javadocButton = new FloatingActionButton.extended(
    //   heroTag: "btn1",
    //   backgroundColor: midCyan,
    //   icon: Icon(Icons.code),
    //   elevation: 0,
    //   focusElevation: 1.5,
    //   label: Text(
    //     'Javadocs',
    //     style: TextStyle(
    //       fontFamily: "Open Sans",
    //       fontWeight: FontWeight.w300,
    //       fontSize: blockSize * 1.3,
    //     ),
    //   ),
    //   onPressed: () {
    //     setState(() {
    //       setJavadoc();
    //     });
    //   },
    // );
    AnimatedOpacity javadocButton = new AnimatedOpacity(
      child: RaisedButton(
        onPressed: () {
          setState(() {
            setJavadoc();
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
                '  Javadocs',
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
      opacity: _javadocOpacity,
    );

    // FloatingActionButton singleLineButton = new FloatingActionButton.extended(
    //   heroTag: "btn2",
    //   backgroundColor: midCyan,
    //   icon: Icon(Icons.subject),
    //   elevation: 0,
    //   focusElevation: 1.5,
    //   label: Text(
    //     '// Comments',
    //     style: TextStyle(
    //       fontFamily: "Open Sans",
    //       fontWeight: FontWeight.w300,
    //       fontSize: blockSize * 1.3,
    //     ),
    //   ),
    //   onPressed: () {
    //     setState(() {
    //       setSingleLine();
    //     });
    //   },
    // );

    AnimatedOpacity singleLineButton = new AnimatedOpacity(
      child: RaisedButton(
        onPressed: () {
          setState(() {
            setSingleLine();
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
                Icons.subject,
                color: lightCyan,
              ),
              Text(
                '  // Comments',
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
      opacity: _singleCommentOpacity,
    );

    // FloatingActionButton whitespaceButton = new FloatingActionButton.extended(
    //   heroTag: "btn3",
    //   backgroundColor: midCyan,
    //   icon: Icon(Icons.space_bar),
    //   elevation: 0,
    //   focusElevation: 1.5,
    //   label: Text(
    //     'Whitespaces',
    //     style: TextStyle(
    //       fontFamily: "Open Sans",
    //       fontWeight: FontWeight.w300,
    //       fontSize: blockSize * 1.3,
    //     ),
    //   ),
    //   onPressed: () {
    //     setState(() {
    //       setWhitespaces();
    //     });
    //   },
    // );

    AnimatedOpacity whitespaceButton = new AnimatedOpacity(
      child: RaisedButton(
        onPressed: () {
          setState(() {
            setWhitespaces();
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
                Icons.space_bar,
                color: lightCyan,
              ),
              Text(
                '  Whitespaces',
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
      opacity: _whitespaceOpacity,
    );

    // FloatingActionButton indentationButton = new FloatingActionButton.extended(
    //   heroTag: "btn4",
    //   backgroundColor: midCyan,
    //   icon: Icon(Icons.format_indent_increase),
    //   elevation: 0,
    //   focusElevation: 1.5,
    //   label: Text(
    //     'Indentations',
    //     style: TextStyle(
    //       fontFamily: "Open Sans",
    //       fontWeight: FontWeight.w300,
    //       fontSize: blockSize * 1.3,
    //     ),
    //   ),
    //   onPressed: () {
    //     setState(() {
    //       setIndentation();
    //     });
    //   },
    // );
    AnimatedOpacity indentationButton = new AnimatedOpacity(
      child: RaisedButton(
        onPressed: () {
          setState(() {
            setIndentation();
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
                Icons.format_indent_increase,
                color: lightCyan,
              ),
              Text(
                '  Indentations',
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
      opacity: _indentationOpacity,
    );

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
                  Text(
                    'Choose an operation',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w300,
                      color: midCyan,
                      fontSize: blockSize * 5.5,
                    ),
                  ),
                  Text(
                    'Choose the operations you want to perform on the .java files.\nThe software will ' +
                    'only apply the selected operations on the contents\nof the .java file and you can download' +
                    ' the fixed version in the next step:\n\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkCyan,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w300,
                      fontSize: blockSize * 1.5,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          javadocButton,
                          Text(
                            '\nAdds Missing\nJavadocs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: blockSize * 1.1,
                              color: darkCyan,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(''),
                          Icon(
                            Icons.check,
                            color: _javadocIcon,
                          ),
                        ],
                      ),
                      Text('\t\t'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          singleLineButton,
                          Text(
                            '\nRemoves Single\nLine Comments',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: blockSize * 1.1,
                              color: darkCyan,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(''),
                          Icon(
                            Icons.check,
                            color: _singleCommentIcon,
                          ),
                        ],
                      ),
                      Text('\t\t'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          whitespaceButton,
                          Text(
                            '\nFixes Incorrect\nWhitespaces',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: blockSize * 1.1,
                              color: darkCyan,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(''),
                          Icon(
                            Icons.check,
                            color: _whitespaceIcon,
                          ),
                        ],
                      ),
                      Text('\t\t'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          indentationButton,
                          Text(
                            '\nFixes Incorrect\nIndentations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: blockSize * 1.1,
                              color: darkCyan,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(''),
                          Icon(
                            Icons.check,
                            color: _indentationIcon,
                          ),
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
                      child: const Text(
                        'Run',
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
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