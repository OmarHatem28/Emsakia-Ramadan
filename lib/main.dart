import 'package:emsakia/CircularListItem.dart';
import 'package:emsakia/Models/CircularItem.dart';
import 'package:emsakia/Models/Data.dart';
import 'package:flutter/material.dart';
import 'package:emsakia/Models/APIResponse.dart';
import 'package:http/http.dart' as http;
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart' as wheel;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'Models/FireStoreSingleton.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emsakia Ramdan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
//        '/0' : (context) => null,
//        '/1' : (context) => null,
//        '/2' : (context) => null,
//        '/3' : (context) => null,
//        '/4' : (context) => null,
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static FireStoreSingleton fireStoreSingleton;
  Stream firebaseStream;
  bool currState = false; // false == show Emsakya, true == show Prayers
  bool notifications = true;
  int startingIndex = 1;
  var width = 0.0;
  final MaterialColor primaryColorShades = MaterialColor(
    0xFF38003C,
    <int, Color>{
      50: Color(0xFF38003C),
      100: Color(0xFF38003C),
      200: Color(0xFF38003C),
      300: Color(0xFF38003C),
      400: Color(0xFF38003C),
      500: Color(0xFF38003C),
      600: Color(0xFF38003C),
      700: Color(0xFF38003C),
      800: Color(0xFF38003C),
      900: Color(0xFF38003C),
    },
  );

  List<CircularItem> listItems = [
    new CircularItem("الامساكية", 'img/ramdan_cover5.jpg'),
    new CircularItem("مواقيت الصلاة", 'img/ramdan_cover1.jpg'),
    new CircularItem("القرأن", 'img/ramdan_cover5.jpg'),
    new CircularItem("الأذكار", 'img/ramdan_cover1.jpg'),
    new CircularItem("السبحة", 'img/ramdan_cover5.jpg'),
  ];

  List<Data> myData = new List();

  @override
  void initState() {
    super.initState();
    firebaseStream = Firestore.instance.collection('ramadan_date').snapshots();
//    fireStoreSingleton = new FireStoreSingleton();
//    firebaseStream = FireStoreSingleton.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorShades,
      body: _buildBody(context),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    final resizeFactor = (1 - (((0 - 0).abs() * 0.3).clamp(0.0, 1.0)));
    return Container(
      color: Color.fromRGBO(38, 0, 39, 0.8),
      width: MediaQuery.of(context).size.width / 1.2,
      child: Swiper(
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: CircleListItem(
              resizeFactor: resizeFactor,
              item: listItems[index],
            ),
            onTap: () {
              if (index == 1) {
                startingIndex = 2;
              }
              setState(() {
                firebaseStream =
                    Firestore.instance.collection('ramadan_date').snapshots();
                currState = !currState;
//                firebaseStream = FireStoreSingleton.getInstance();
                Navigator.pop(context);
              });
            },
          );
        },
//          index: startingIndex,
        viewportFraction: 0.3,
        scale: 0.0001,
        fade: 0.01,
        scrollDirection: Axis.vertical,
        physics: FixedExtentScrollPhysics(),
//          onTap: (i) => print ("outside "+i.toString()),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
          child: Container(
        child: Column(
          children: <Widget>[
            _buildBackdrop(),
            currState ? _buildPrayerTimes() : Container(),
          ],
        ),
      )),
    );
  }

  Widget _buildBackdrop() {
    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        width = constraints.biggest.width;
        return Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipPath(
                    clipper: Mclipper(),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 10.0),
                                blurRadius: 10.0)
                          ]),
                      child: Container(
                        width: width,
                        height: width,
                        child: Image.asset(
                          "img/ramdan_cover5.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        currState
                            ? Text(
                                "اليوم",
                                style: TextStyle(
                                  color: Color(0xFFFFC819),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'Tajawal',
                                ),
                              )
                            : showIftarImsakTime("الامساك"),
                        Expanded(
                          child: Container(),
                        ),
                        currState
                            ? Text(
                                "مواقيت",
                                style: TextStyle(
                                  color: Color(0xFFFFC819),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'Tajawal',
                                ),
                              )
                            : showIftarImsakTime("الافطار"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            notificationAlert(),
            drawerIndicator(context),
          ],
        );
      }),
    );
  }

  Widget _buildPrayerTimes() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 300.0,
          child: StreamBuilder<QuerySnapshot>(
            stream: firebaseStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              snapshot.data.documents.sort((docA, docB) => (docA.data['date']
                      ['hijri']['day'])
                  .toString()
                  .compareTo((docB.data['date']['hijri']['day']).toString()));
              snapshot.data.documents.forEach((doc) {
                myData.add(Data.fromSnapshot(doc));
              });
              return buildSchedule(myData);
            },
          ),
        ),
      ],
    );
  }

  Widget buildSchedule(List<Data> data) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "الفجر",
            style: MyTextStyle.minorText,
          ),
          trailing: Text(
            data[0].timings.fajr,
            style: MyTextStyle.minorText,
          ),
        ),
        ListTile(
          title: Text(
            "الظهر",
            style: MyTextStyle.minorText,
          ),
          trailing: Text(
            data[0].timings.dhuhr,
            style: MyTextStyle.minorText,
          ),
        ),
        ListTile(
          title: Text(
            "العصر",
            style: MyTextStyle.minorText,
          ),
          trailing: Text(
            data[0].timings.asr,
            style: MyTextStyle.minorText,
          ),
        ),
        ListTile(
          title: Text(
            "المغرب",
            style: MyTextStyle.minorText,
          ),
          trailing: Text(
            data[0].timings.maghrib,
            style: MyTextStyle.minorText,
          ),
        ),
        ListTile(
          title: Text(
            "العشاء",
            style: MyTextStyle.minorText,
          ),
          trailing: Text(
            data[0].timings.isha,
            style: MyTextStyle.minorText,
          ),
        ),
      ],
    );
  }

  Widget showIftarImsakTime(String which) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              which,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'Tajawal',
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: StreamBuilder<QuerySnapshot>(
              stream: firebaseStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                // TODO: adjust data to be for every day not just the first
                String iftar = Data.fromSnapshot(snapshot.data.documents[0])
                    .timings
                    .maghrib;
                String imsak =
                    Data.fromSnapshot(snapshot.data.documents[0]).timings.imsak;
                return Text(
                  which == "الامساك" ? imsak : iftar,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Tajawal',
                  ),
                );
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Color(0xFFFFC819), width: 3),
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationAlert() {
    return Positioned(
      right: width / 2 - 25,
      top: width,
      child: FractionalTranslation(
        translation: Offset(0.0, -0.5),
        child: FloatingActionButton(
          onPressed: () {
            notifications = !notifications;
            setState(() {});
          },
          backgroundColor: Colors.white,
          child: Icon(
            notifications
                ? Icons.notifications_active
                : Icons.notifications_off,
            color: notifications ? Colors.green : Colors.grey,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget drawerIndicator(BuildContext context) {
    return Positioned(
      left: width / 10 - 60,
      top: width - 40,
      child: FractionalTranslation(
        translation: Offset(0.0, -0.5),
        child: GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            Scaffold.of(context).openDrawer();
          },
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: Colors.white),
            child: Icon(
              Icons.arrow_forward,
              color: primaryColorShades,
              size: 40,
            ),
            padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
          ),
        ),
      ),
    );
  }

//  Future<APIResponse> getPrayers() async {
//    final response = await http.get(
//        'http://api.aladhan.com/v1/hijriCalendarByCity?city=cairo&country=Egypt&method=5&month=09&year=1440');
//    if (response.statusCode == 200) {
//      return APIResponse.fromJson(jsonDecode(response.body));
//    } else {
//      throw Exception("Check Your Internet Connection");
//    }
//  }
}

abstract class MyTextStyle {
  static const minorText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Tajawal',
  );
}

class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 40.0);

    var controlPoint = Offset(size.width / 4, size.height);
    var endpoint = Offset(size.width / 2, size.height);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endpoint.dx, endpoint.dy);

    var controlPoint2 = Offset(size.width * 3 / 4, size.height);
    var endpoint2 = Offset(size.width, size.height - 40.0);

    path.quadraticBezierTo(
        controlPoint2.dx, controlPoint2.dy, endpoint2.dx, endpoint2.dy);

    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
