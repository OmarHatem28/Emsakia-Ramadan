import 'package:emsakia/main.dart';
import 'package:flutter/material.dart';

class Azkar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildCard(context, 'img/morning1.jpg', "أذكار الصباح", primaryColorShades, '/morning_zekr'),
          ),
          Divider(
            height: 10,
            color: Color(0xFFFFC819),
          ),
          Expanded(
            child: buildCard(context, 'img/evening3.jpg', "أذكار المساء", Color(0xFFFFC819), '/evening_zekr'),
          ),
        ],
      ),
      backgroundColor: primaryColorShades,
    );
  }

  Widget buildCard(BuildContext context, String imgPath, String title, Color color, String route) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Card(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: AssetImage(imgPath),
                    fit: BoxFit.fill,
                  )),
            ),
            elevation: 32,
            margin: EdgeInsets.fromLTRB(20, 50, 20, 40),
            shape: StadiumBorder(),
          ),
          Align(
            child: Text(
              title,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  fontSize: 32),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
  
}
