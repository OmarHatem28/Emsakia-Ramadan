import 'package:emsakia/CircularListItem.dart';
import 'package:emsakia/Models/CircularItem.dart';
import 'package:emsakia/Models/DateAndTime/Data.dart';
import 'package:emsakia/azkar.dart';
import 'package:emsakia/doaa.dart';
import 'package:emsakia/evening_zekr.dart';
import 'package:emsakia/morning_zekr.dart';
import 'package:flutter/material.dart';
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
      routes: {
        '/azkar' : (context) => Azkar(),
        '/evening_zekr' : (context) => EveningZekr(),
        '/morning_zekr' : (context) => MorningZekr(),
        '/doaa' : (context) => Doaa(),
      },
    );
  }
}

final MaterialColor primaryColorShades = MaterialColor(
  0xFF260028,
  <int, Color>{
    50: Color(0xFF260028),
    100: Color(0xFF260028),
    200: Color(0xFF260028),
    300: Color(0xFF260028),
    400: Color(0xFF260028),
    500: Color(0xFF260028),
    600: Color(0xFF260028),
    700: Color(0xFF260028),
    800: Color(0xFF260028),
    900: Color(0xFF260028),
  },
);

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  static FireStoreSingleton fireStoreSingleton;
  Stream firebaseStream;
  bool currState = false; // false == show Emsakya, true == show Prayers
  bool notifications = true;
  int startingIndex = 0;
  var width = 0.0;

  List<CircularItem> listItems = [
    new CircularItem("الامساكية", 'img/ramdan_cover5.webp'),
    new CircularItem("مواقيت الصلاة", 'img/ramdan_cover1.webp'),
    new CircularItem("الأذكار", 'img/ramdan_cover5.webp'),
    new CircularItem("الأدعية", 'img/ramdan_cover5.webp'),
    new CircularItem("القرأن", 'img/ramdan_cover1.webp'),
  ];

  List<Data> myData = new List();

  @override
  void initState() {
    super.initState();
    firebaseStream = Firestore.instance.collection('ramadan_date').snapshots();
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
          return CircleListItem(
            resizeFactor: resizeFactor,
            item: listItems[index],
          );
        },
        onTap: (index) {
          Navigator.pop(context);
          startingIndex = index;
          if ( (index == 0 && currState ) || (index == 1 && !currState ) ) {
            //if what is showing now is Prayer Times, show Emsakya and vice versa
            setState(() {
              currState = !currState;
            });
          } else if (index == 2 ) {
            Navigator.pushNamed(context, '/azkar');
          } else if (index == 3 ) {
            Navigator.pushNamed(context, '/doaa');
          }
        },
        index: 1,
        viewportFraction: 0.3,
        scale: 0.0001,
        fade: 0.01,
        scrollDirection: Axis.vertical,
        physics: FixedExtentScrollPhysics(),
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
            currState ? _buildPrayerTimes() : buildCurrDay(),
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
                          "img/ramdan_cover5.webp",
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
                                style: MyTextStyle.titles,
                              )
                            : showIftarImsakTime("الامساك"),
                        Expanded(
                          child: Container(),
                        ),
                        currState
                            ? Text(
                                "مواقيت",
                          style: MyTextStyle.titles,
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
          height: 300,
          child: myData.isEmpty ? scheduleStream() : buildSchedule(myData),
        ),
      ],
    );
  }

  Widget buildCurrDay() {
    if ( myData.isEmpty ){
      return StreamBuilder<QuerySnapshot>(
        stream: firebaseStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 12),
              child: CircularProgressIndicator(),
            );
          }

          sortDocs(snapshot);
          if ( myData.isEmpty ){
            snapshot.data.documents.forEach((doc) {
              myData.add(Data.fromSnapshot(doc));
            });
          }
          int index = getDayIndex();
          var date = DateTime.now();
          if ( date.day < 6 && date.month == 5 ){
            index = 30-(6-date.day);
            return Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 12),
              child: Text((index+1).toString()+" شعبان", textDirection: TextDirection.rtl, style: MyTextStyle.titles,),
            );
          }
          return Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 12),
            child: Text((index+1).toString()+" رمضان", textDirection: TextDirection.rtl, style: MyTextStyle.titles,),
          );
        },
      );
    }
    int index = getDayIndex();
    var date = DateTime.now();
    if ( date.day < 6 && date.month == 5 ){
      index = 30-(6-date.day);
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 12),
        child: Text((index+1).toString()+" شعبان", textDirection: TextDirection.rtl, style: MyTextStyle.titles,),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 12),
      child: Text((index+1).toString()+" رمضان", textDirection: TextDirection.rtl, style: MyTextStyle.titles,),
    );
  }

  Widget scheduleStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        sortDocs(snapshot);
        if ( myData.isEmpty ){
          snapshot.data.documents.forEach((doc) {
            myData.add(Data.fromSnapshot(doc));
          });
        }
        return buildSchedule(myData);
      },
    );
  }

  Widget iftarImsakTimesStream(String which) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        sortDocs(snapshot);
        if ( myData.isEmpty ){
          snapshot.data.documents.forEach((doc) {
            myData.add(Data.fromSnapshot(doc));
          });
        }
        int index = getDayIndex();
        String iftar = myData[index].timings.maghrib;
        String imsak = myData[index].timings.imsak;
        return Text(
          which == "الامساك" ? imsak : iftar,
          style: MyTextStyle.minorText,
        );
      },
    );
  }

  void sortDocs(AsyncSnapshot<QuerySnapshot> snapshot) {
    snapshot.data.documents.sort((docA, docB) => (docA.data['date']
    ['hijri']['day'])
        .toString()
        .compareTo((docB.data['date']['hijri']['day']).toString()));
  }

  int getDayIndex() {
    int day = DateTime.now().day;
    for ( int i = 0;i<myData.length;i++){
      int tempDay = int.parse(myData[i].date.readable.substring(0,2));
      if ( day == tempDay ){
        return i;
      }
    }
    return 0;
  }

  Widget buildSchedule(List<Data> data) {
    List<String> names = new List();
    List<String> times = new List();
    names.add("الفجر");
    names.add("الظهر");
    names.add("العصر");
    names.add("المغرب");
    names.add("العشاء");
    int index = getDayIndex();
    times.add(data[index].timings.fajr);
    times.add(data[index].timings.dhuhr);
    times.add(data[index].timings.asr);
    times.add(data[index].timings.maghrib);
    times.add(data[index].timings.isha);
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        if (index % 2 == 1) return Divider();

        int i = index ~/ 2;
        return Container(
          margin: EdgeInsets.fromLTRB(20, 0, 25, 0),
          child: ListTile(
            title: Text(
              times[i],
              style: MyTextStyle.minorText,
            ),
            trailing: Text(
              names[i],
              style: MyTextStyle.minorText,
            ),
          ),
        );
      },
    );
  }

  Widget showIftarImsakTime(String which) {
    String iftar;
    String imsak;
    int index = getDayIndex();
    bool available = false;
    if ( myData.isNotEmpty ){
      iftar = myData[index].timings.maghrib;
      imsak = myData[index].timings.imsak;
      available = true;
    }
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              which,
              style: MyTextStyle.titles,
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: available ? Text(
              which == "الامساك" ? imsak : iftar,
              style: MyTextStyle.minorText,
            ) : iftarImsakTimesStream(which),
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
    fontSize: 18,
    fontFamily: 'Tajawal',
  );

  static const titles = TextStyle(
    color: Color(0xFFFFC819),
    fontWeight: FontWeight.bold,
    fontSize: 30,
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
