import 'package:emsakia/CircularListItem.dart';
import 'package:emsakia/Models/CircularItem.dart';
import 'package:flutter/material.dart';
import 'package:emsakia/Models/APIResponse.dart';
import 'package:http/http.dart' as http;
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart' as wheel;
import 'dart:convert';

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

  List<CircularItem> listItems = [
    new CircularItem("Quran", 'img/ramdan_cover5.jpg'),
    new CircularItem("Azkar", 'img/ramdan_cover5.jpg'),
    new CircularItem("Ad3ya", 'img/ramdan_cover5.jpg'),
    new CircularItem("Seb7a", 'img/ramdan_cover5.jpg'),
    new CircularItem("A7adeeth", 'img/ramdan_cover5.jpg'),
  ];

  _listListener() {
    setState(() {});
  }

  Future<APIResponse> results;

  @override
  void initState() {
    super.initState();
    results = getPrayers();
    _controller = wheel.FixedExtentScrollController();
    _controller.addListener(_listListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 117, 25, 1),
      body: Stack(
        children: <Widget>[
          _buildBody(context),
        ],
      ),
      drawer: wheel.CircleListScrollView.useDelegate(
          itemExtent: 120,
          physics: wheel.CircleFixedExtentScrollPhysics(),
          controller: _controller,
          axis: Axis.vertical,
          radius: MediaQuery.of(context).size.width * 0.8,
          childDelegate: wheel.CircleListChildBuilderDelegate(
            builder: (context, index) {
              int currentIndex = 0;
              try {
                currentIndex = _controller.selectedItem;
              } catch (_) {}
              final resizeFactor =
                  (1 - (((currentIndex - index).abs() * 0.3).clamp(0.0, 1.0)));
              return CircleListItem(
                resizeFactor: resizeFactor,
                item: listItems[index],
              );
            },
            childCount: listItems.length,
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
          child: Container(
        child: Column(
          children: <Widget>[
            _buildBackdrop(context),
            _buildPrayerTimes(),
          ],
        ),
      )),
    );
  }

  _buildBackdrop(BuildContext context) {
    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var width = constraints.biggest.width;
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
                          "img/ramdan_cover1.jpg",
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
                        IconButton(
                          icon: Icon(
                            Icons.add,
                          ),
                          onPressed: () {
                            debugPrint("Hello");
                          },
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                          ),
                          onPressed: () {
                            debugPrint("Hello");
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: width / 2 - 25,
              top: width,
              child: FractionalTranslation(
                translation: Offset(0.0, -0.5),
                child: FloatingActionButton(
                  onPressed: () {
                    print('Touch');
                  },
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.notifications_active,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
            )
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
          child: FutureBuilder<APIResponse>(
            future: results,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildSchedule(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }

  Future<APIResponse> getPrayers() async {
    final response = await http.get(
        'http://api.aladhan.com/v1/hijriCalendarByCity?city=cairo&country=Egypt&method=5&month=09&year=1440');
    if (response.statusCode == 200) {
      return APIResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Check Your Internet Connection");
    }
  }

  Widget buildSchedule(APIResponse response) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Fajr"),
          trailing: Text(response.data[0].timings.fajr),
        ),
        ListTile(
          title: Text("Duhr"),
          trailing: Text(response.data[0].timings.dhuhr),
        ),
        ListTile(
          title: Text("Asr"),
          trailing: Text(response.data[0].timings.asr),
        ),
        ListTile(
          title: Text("Maghrib"),
          trailing: Text(response.data[0].timings.maghrib),
        ),
        ListTile(
          title: Text("Isha"),
          trailing: Text(response.data[0].timings.isha),
        ),
      ],
    );
  }
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
