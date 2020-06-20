import 'dart:io';
import 'dart:ui';
import 'dart:html';
import 'package:ICE/filedownload.dart';
import 'package:ICE/operation.dart';
import 'package:flutter/material.dart';
import 'package:ICE/directory.dart';
import 'package:url_launcher/url_launcher.dart';

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
MaterialColor lightCyan = MaterialColor(0xFFe3ecef, cyanColorCodes);
MaterialColor midCyan = MaterialColor(0xFF6493a1, cyanColorCodes);

void main() {
  runApp(MyApp());
}

/* Main application that runs UI. */
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

/* Home page that users first see upon opening the application. */
class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  /*
   * A helper method that generates text based on the 
   * size, text, color and alignment. 
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

  @override
  Widget build(BuildContext context) {
    /* Measurements used to resize elements based on window size. */
    double width = MediaQuery.of(context).size.width;

    /* Widget that controlls the scrolling of the page. */
    PageController scrollController = PageController(initialPage: 0);

    /* File download page where users download their fixed java files. */
    MyFileDownloadPage fileDownloadPage = MyFileDownloadPage(homepage: widget, controller: scrollController, disabled: true);
    
    /* Operation page where users select which operations to perform. */
    MyOperationPage operationPage = MyOperationPage(homepage: widget, controller: scrollController, nextPage: fileDownloadPage, disabled: true);
    
    /* The choose file page where users choose the inital file. */
    MyDirectoryPage directoryPage = MyDirectoryPage(homepage: widget, controller: scrollController, nextPage: operationPage);
    
    /* Setting the page references for the file download page. */
    fileDownloadPage.setPageRef1(directoryPage);
    fileDownloadPage.setPageRef2(widget);

    /*
     * Listener for the scroll controller that jumps back to a certain 
     * scroll position based on which pages are disabled. 
     */
    // scrollListener() {
    //   print(operationPage.disabled);
    //   print(fileDownloadPage.disabled);
    //   if (operationPage.disabled && fileDownloadPage.disabled) {
    //     // if (scrollController.offset > 750) {
    //     //   scrollController.jumpTo(749);
    //     // }
    //   }
    //   if (fileDownloadPage.disabled) {
    //     if (scrollController.offset > 1500) {
    //       scrollController.jumpTo(1499);
    //     }
    //   }
    // }

    /* Adding listeners to the scroll controller and pages. */
    // scrollController.addListener(scrollListener);
    // directoryPage.setListener(scrollListener);
    // operationPage.setListener(scrollListener);
    // fileDownloadPage.setListener(scrollListener);

    /* Main scaffold widget of the app that displays the UI elements. */
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.6,
        centerTitle: true,
        actions: [
          RaisedButton(
            color: lightCyan,
            hoverElevation: 0,
            elevation: 0,
            focusElevation: 0,
            onPressed: () async {
              const url = "https://docs.google.com/forms/d/1A8qwG5T8pZIKmCaPYYSiEoqgzKsWMKBYmpUAqJ4zWw0/prefill";
              if (await canLaunch(url)) {
                launch(url);
              } 
            },
            child: getText(15, 'Contact Us', midCyan, TextAlign.center),
          ),
          Text('\t\t\t'),
        ],
        backgroundColor: lightCyan,
        elevation: 2,
        title: getText(15, 'ICEcap v1.0', midCyan, TextAlign.center),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1440,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: scrollController,
            children: [
              Container(
                height: 750,
                color: lightCyan,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(
                          alignment: Alignment.center,
                          repeat: ImageRepeat.noRepeat,
                          image: AssetImage('assets/mountains.png'),
                          width: 450,
                          height: 450,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getText(150, 'ICEcΔp', midCyan, TextAlign.left),
                            getText(28, '(Interactive Convention Editor)\n\n', midCyan, TextAlign.left),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getText(
                          22, 
                          'We all have faced issues with the 200+ style check' + 
                          ' errors that appear right when we are ready to submit ' + 
                          'our\nCS 61B projects. In three easy steps below you can get rid of many style check errors from your project.\n\n',
                          darkCyan,
                          TextAlign.center
                        ),
                        RaisedButton(
                          onPressed: () {
                            scrollController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                            // scrollController.animateTo(750, duration: Duration(milliseconds: 500), curve: Curves.ease);
                          },
                          color: midCyan,
                          textColor: lightCyan,
                          elevation: 0,
                          padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                          focusElevation: 2.0,
                          child: getText(18, 'Start', lightCyan, TextAlign.center),
                        ),
                        Text("\n\n\n"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 750,
                color: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: directoryPage,
              ),
              Container(
                height: 750,
                color: lightCyan,
                alignment: Alignment.center,
                child: operationPage,
              ),
              Container(
                height: 750,
                color: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    fileDownloadPage,
                    Container(
                      color: lightCyan,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        "\nCreated by two fellow 61Bers, Pranati & Khushi\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: darkCyan,
                        ),
                      ),
                    ), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}