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

    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  wheel.FixedExtentScrollController _controller;
  bool notifications = true;
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
    new CircularItem("Quran", 'img/ramdan_cover5.jpg'),
    new CircularItem("Azkar", 'img/ramdan_cover1.jpg'),
    new CircularItem("Ad3ya", 'img/ramdan_cover5.jpg'),
    new CircularItem("Seb7a", 'img/ramdan_cover1.jpg'),
    new CircularItem("A7adeeth", 'img/ramdan_cover5.jpg'),
  ];

  _listListener() {
    print("hi");
  }

  List<Data> myData = new List();
  Stream firebaseStream;

  @override
  void initState() {
    super.initState();
    _controller = wheel.FixedExtentScrollController();
//    _controller.addListener(_listListener);
    firebaseStream = Firestore.instance.collection('ramadan_date').snapshots();
  }

  @override
  void dispose() {
//    _controller.removeListener(_listListener);
//    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorShades,
      body: _buildBody(context),
      drawer: Drawer(
        child: Container(
          child: _buildDrawer(),
          color: primaryColorShades,
        ),
      ),
    );
  }

  Widget _buildItem(int i) {
    final resizeFactor = (1 - (((0 - i).abs() * 0.3).clamp(0.0, 1.0)));
    return GestureDetector(
      child: CircleListItem(
        resizeFactor: resizeFactor,
        item: listItems[i],
      ),
      onTap: () => print("omar " + i.toString()),
//      behavior: HitTestBehavior.opaque,
    );
  }

  Widget _buildDrawer() {
    final resizeFactor = (1 - (((0 - 0).abs() * 0.3).clamp(0.0, 1.0)));
    return SafeArea(
      child: Center(
        child: Swiper(
          itemCount: 5,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: CircleListItem(
                resizeFactor: resizeFactor,
                item: listItems[index],
              ),
              onTap: () => print("inside "+index.toString()),
            );
          },
          viewportFraction: 0.3,
          scale: 0.0001,
          fade: 0.01,
          scrollDirection: Axis.vertical,
          physics: FixedExtentScrollPhysics(),
//          onTap: (i) => print ("outside "+i.toString()),
        ),
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
            _buildPrayerTimes(),
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
                        showIftarImsakTime("الامساك"),
                        Expanded(
                          child: Container(),
                        ),
                        showIftarImsakTime("الافطار"),
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
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          trailing: Text(
            data[0].timings.fajr,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        ListTile(
          title: Text(
            "الظهر",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          trailing: Text(
            data[0].timings.dhuhr,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        ListTile(
          title: Text(
            "العصر",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          trailing: Text(
            data[0].timings.asr,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        ListTile(
          title: Text(
            "المغرب",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          trailing: Text(
            data[0].timings.maghrib,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        ListTile(
          title: Text(
            "العشاء",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          trailing: Text(
            data[0].timings.isha,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
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
                String iftar = myData[0].timings.maghrib;
                String imsak = myData[0].timings.imsak;
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
        child: FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          backgroundColor: Colors.white,
          child: Container(
            child: Icon(
              Icons.arrow_forward,
              color: primaryColorShades,
              size: 40,
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
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
