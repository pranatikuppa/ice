import 'dart:io';
import 'dart:ui';
import 'dart:html';
import 'package:ICE/filedownload.dart';
import 'package:ICE/operation.dart';
import 'package:flutter/material.dart';
import 'package:ICE/directory.dart';
import 'package:url_launcher/url_launcher.dart';

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
      title: 'ICEcap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: darkCyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  ScrollPhysics scrollPhysics;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double blockSize = width/100;
    ScrollController scrollController = ScrollController();
    MyFileDownloadPage fileDownloadPage = MyFileDownloadPage(homepage: widget, controller: scrollController, disabled: true);
    MyOperationPage operationPage = MyOperationPage(homepage: widget, controller: scrollController, nextPage: fileDownloadPage, disabled: true);
    MyDirectoryPage directoryPage = MyDirectoryPage(homepage: widget, controller: scrollController, nextPage: operationPage);
    fileDownloadPage.setPageRef1(directoryPage);
    fileDownloadPage.setPageRef2(widget);
    scrollListener() {
      if (directoryPage.nextPage.disabled) {
        if (scrollController.offset > 800) {
          scrollController.jumpTo(799);
        }
      }
      if (operationPage.nextPage.disabled) {
          if (scrollController.offset > 1600) {
            scrollController.jumpTo(1599);
          }
        }
    }
    scrollController.addListener(scrollListener);
    scrollController.addListener(scrollListener);
    directoryPage.setListener(scrollListener);
    operationPage.setListener(scrollListener);
    fileDownloadPage.setListener(scrollListener);


    return Scaffold(
      body: FractionallySizedBox(
        child: Container(
          color: lightCyan,
          alignment: Alignment.center,
          child: CustomScrollView(
            physics: widget.scrollPhysics,
            controller: scrollController,
            slivers: [
              SliverAppBar(
                titleSpacing: 0.6,
                collapsedHeight: 57,
                centerTitle: true,
                actions: [
                  RaisedButton(
                    color: lightCyan,
                    hoverElevation: 0,
                    elevation: 0,
                    focusElevation: 0,
                    onPressed: () async {
                      const url = "https://flutter.io";
                      if (await canLaunch(url)) {
                        launch(url);
                      } 
                    },
                    child: getText(blockSize * 1.2, 'Contact Us', midCyan, TextAlign.center),
                  ),
                  Text('\t\t\t'),
                ],
                pinned: true,
                backgroundColor: lightCyan,
                elevation: 2,
                title: getText(blockSize * 1.2, 'ICEcap v1.0', midCyan, TextAlign.center),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(
                          alignment: Alignment.center,
                          repeat: ImageRepeat.noRepeat,
                          image: AssetImage('assets/mountains.png'),
                          width: blockSize * 35,
                          height: blockSize * 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getText(blockSize * 12, 'ICEcΔp', midCyan, TextAlign.left),
                            getText(blockSize * 2.4, '(Interactive Convention Editor)\n\n', midCyan, TextAlign.left),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        getText(
                          blockSize * 1.6, 
                          'We all have faced issues with the 200+ style check' + 
                          ' errors that appear right when we are ready to submit ' + 
                          'our\nCS 61B projects. In three easy steps below you can get rid of many style check errors from your project.\n\n',
                          darkCyan,
                          TextAlign.center
                        ),
                        RaisedButton(
                          onPressed: () {
                            scrollController.animateTo(800, duration: Duration(milliseconds: 500), curve: Curves.ease);
                          },
                          color: midCyan,
                          textColor: lightCyan,
                          elevation: 0,
                          padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                          focusElevation: 2.0,
                          child: getText(blockSize * 1.4, 'Start', lightCyan, TextAlign.center),
                        ),
                        Text("\n\n\n"),
                      ],
                    ),
                    Container(
                      width: 20,
                      height: 800,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 70, top: 70),
                      child: directoryPage,
                    ),
                    Container(
                      width: 20,
                      height: 800,
                      color: lightCyan,
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 50, top: 50),
                      child: operationPage,
                    ),
                    Container(
                      width: 20,
                      height: 800,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 50, top: 50),
                      child: fileDownloadPage,
                    ),
                    Text(
                      "\nCreated by two fellow 61Bers, Pranati & Khushi\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Open Sans",
                        fontSize: blockSize * 1.3,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: darkCyan,
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}