import 'package:flutter/material.dart';
import 'package:emsakia/Models/Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Prayers extends StatelessWidget {

  final List<Data> myData = new List();
  final Stream firebaseStream = Firestore.instance.collection('ramadan_date').snapshots();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildPrayerTimes(),
    );
  }

  Widget _buildPrayerTimes() {
    return Container(
      color: primaryColorShades,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 300.0,
            child: StreamBuilder<QuerySnapshot>(
              stream: firebaseStream,
              builder: (context, snapshot) {
                print(snapshot.hasData);
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
      ),
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

}