import 'dart:ui';

import 'package:flutter/material.dart';
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
MaterialColor lightCyan = MaterialColor(0xFFe3ecef, cyanColorCodes);
MaterialColor midCyan = MaterialColor(0xFF6493a1, cyanColorCodes);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: darkCyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ICE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void nextPage(BuildContext context) {
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
        widthFactor: 1350,
        heightFactor: 650,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 10),
          color: lightCyan,
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image(
                    alignment: Alignment.bottomLeft,
                    repeat: ImageRepeat.noRepeat,
                    image: AssetImage('assets/mountains.png'),
                    width: blockSize * 30,
                    height: blockSize * 30,
                  ),
                  Text(
                    'Welcome to ICE',
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w300,
                      fontSize: blockSize * 8,
                      color: midCyan,
                    ),
                  ),
                  Text(
                    '(Interactive Convention Editor)',
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w300,
                      fontSize: blockSize * 2,
                      color: midCyan,
                    ),
                  ),
                  Text(''),
                  Text(
                    'We all have faced issues with the 200+ style check' + 
                    ' errors that appear right when we are ready to submit ' + 
                    'our CS 61B projects.\nIn three easy steps you can get rid of many style check errors from your project.',
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w300,
                      fontSize: blockSize * 1.3,
                      color: darkCyan,
                    ),
                  ),
                  Text("\n"),
                  Text(
                    "Created by two fellow 61Bers, Pranati & Khushi",
                    style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: blockSize * 0.9,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      color: darkCyan,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton (
                    onPressed: () {nextPage(context);}, 
                    icon: Icon(
                      Icons.arrow_forward_ios,
                    ),
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
