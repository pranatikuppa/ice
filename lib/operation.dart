import 'dart:ui';
import 'package:ICE/directory.dart';
import 'package:ICE/filedownload.dart';
import 'package:ICE/indentations.dart';
import 'package:ICE/main.dart';
import 'package:ICE/rmmultiline.dart';
import 'package:ICE/singlelines.dart';
import 'package:flutter/material.dart';
import 'package:ICE/javadocs.dart';
import 'package:ICE/whitespace.dart';

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

/* The operation page section where users can select which operations to perform on their files. */
class MyOperationPage extends StatefulWidget {
  MyOperationPage({Key key, this.homepage, this.controller, this.nextPage, this.disabled, this.listener}) : super(key: key);
  
  /* Instances variables of the operation page section */
  bool disabled;
  final ScrollController controller;
  final MyFileDownloadPage nextPage; 
  String fileContents;
  String fixedFileContent;
  var listener;
  final MyHomePage homepage;

  /* Sets the file contents provided to the corresponding instance variable. */
  void setFileContents(String contents) {
    fileContents = contents;
  }

  /* Resets the status of all variables in the section. */
  void resetAll() {

  }

  /* Sets the listener of this page section to the give function list. */
  void setListener(void Function() list) {
    listener = list;
  }

  @override
  _MyOperationPageState createState() => _MyOperationPageState();
}

/* The state of the operation page section. */
class _MyOperationPageState extends State<MyOperationPage> {
  /* All the variables that are needed to keep track of the operation page section's state. */
  bool _javadoc = false;
  bool _singleComment = false;
  bool _whitespace = false;
  bool _indentation = false;
  bool _multiComment = false;
  Color _javadocIcon = lightCyan;
  Color _singleCommentIcon = lightCyan;
  Color _multiCommentIcon = lightCyan;
  Color _whitespaceIcon = lightCyan;
  Color _indentationIcon = lightCyan;
  double _javadocOpacity = 0.5;
  double _singleCommentOpacity = 0.5;
  double _multiCommentOpacity = 0.5;
  double _whitespaceOpacity = 0.5;
  double _indentationOpacity = 0.5;
  Color _errorColor = lightCyan;

  /* 
   * Sets the state of the page by moving to the next page section. 
   * Moves the page down using the scroll controller and passes along
   * user data.
   */
  void nextPage(String result) {
    setState(() {
      widget.fixedFileContent = result;
      widget.nextPage.setFixedFileContents(widget.fixedFileContent);
      widget.controller.animateTo(2400, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  /*
   * Sets the javadoc operation status based on 
   * the current value. Toggles between true and false
   * updating the UI as needed. 
   */
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

  /*
   * Sets the single line operation status based on 
   * the current value. Toggles between true and false
   * updating the UI as needed. 
   */
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

  /*
   * Sets the multiline operation status based on 
   * the current value. Toggles between true and false
   * updating the UI as needed. 
   */
  void setMultiLine() {
    if (!_multiComment) {
      _multiComment = true;
      _multiCommentIcon = midCyan;
      _multiCommentOpacity = 1;
    } else {
      _multiComment = false;
      _multiCommentIcon = lightCyan;
      _multiCommentOpacity = 0.5;
    }
  }

  /*
   * Sets the whitespace operation status based on 
   * the current value. Toggles between true and false
   * updating the UI as needed. 
   */
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

  /*
   * Sets the indentation operation status based on 
   * the current value. Toggles between true and false
   * updating the UI as needed. 
   */
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

  /*
   * Runs the software using all the operation states 
   * and returns the updated contents after applying all 
   * selected operations.  
   */
  String runSoftware(String file, bool javdoc, bool comment, bool multicomment, bool space, bool indent) {
    String contents = file;
    if (comment) {
      SingleLineComments comments = new SingleLineComments();
      contents = comments.main(contents);
    }
    if (multicomment) {
      RmMultiLineComments multis = new RmMultiLineComments();
      contents = multis.main(contents);
    }
    if (indent) {
      Indentations indents = new Indentations();
      contents = indents.main(contents);
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

  /*
   * Helper method that returns an animated opacity raised button 
   * that is used for the users to select the operation. Takes in
   * the method to be called upon pressing, the button text
   * and the opacity of the button.  
   */
  AnimatedOpacity getOpacityButton(var method, String buttonText, double opac, Icon customIcon) {
    return AnimatedOpacity(
      child: RaisedButton(
        onPressed: () {
          setState(() {
            if (!widget.disabled) {
              method();
            }
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
              customIcon,
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

  /*
   * Helper method that returns a text widget based on
   * the size, text, color and alignment.  
   */
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

  /*
   * Returns a check icon with the specified 
   * color variable linked to the icon. 
   */
  Icon getIcon(Color iconCol) {
    return Icon(
      Icons.check,
      color: iconCol,
    );
  }

  @override
  Widget build(BuildContext context) {  
    /* Measurements used to resize elements based on window size. */
    double width = MediaQuery.of(context).size.width;
    double blockSize = width / 100;

    /* Icons for each of the buttons for each operation. */
    Icon jIcon = Icon(Icons.description, color: lightCyan);
    Icon sIcon = Icon(Icons.subject, color: lightCyan);
    Icon mIcon = Icon(Icons.code, color: lightCyan);
    Icon wIcon = Icon(Icons.space_bar, color: lightCyan);
    Icon iIcon = Icon(Icons.format_indent_increase, color: lightCyan);

    /* Buttons for each operation provided in the application. */
    AnimatedOpacity javadocButton = getOpacityButton(setJavadoc, '  Javadocs', _javadocOpacity, jIcon);
    AnimatedOpacity singleLineButton = getOpacityButton(setSingleLine, '  // Comments', _singleCommentOpacity, sIcon);
    AnimatedOpacity multiCommentButton = getOpacityButton(setMultiLine, '  /* Comments', _multiCommentOpacity, mIcon);
    AnimatedOpacity whitespaceButton = getOpacityButton(setWhitespaces, '  Whitespaces', _whitespaceOpacity, wIcon); 
    AnimatedOpacity indentationButton = getOpacityButton(setIndentation, '  Indentations', _indentationOpacity, iIcon);

    /* The container widget that displays all the UI elements of the page seciton. */
    return Container(
      color: lightCyan,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
                      multiCommentButton,
                      getText(blockSize * 1.1, '\nRemoves Multi\nLine Comments', darkCyan, TextAlign.center),
                      Text(''),
                      getIcon(_multiCommentIcon),
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
                  if (!widget.disabled) {
                    if (!_javadoc && !_singleComment && !_multiComment && !_indentation && !_whitespace) {
                      setState(() {
                        _errorColor = Colors.red;
                      });
                    } else {
                      String result = "";
                      setState(() {
                        _errorColor = lightCyan;
                        result = runSoftware(widget.fileContents, _javadoc, _singleComment, _multiComment, _whitespace, _indentation);
                        widget.nextPage.disabled = false;
                      });
                      nextPage(result);
                    }
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
        ],
      ),
    );
  }
}