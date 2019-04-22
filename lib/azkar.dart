import 'package:emsakia/main.dart';
import 'package:flutter/material.dart';

class Azkar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: buildCards(context),
      backgroundColor: primaryColorShades,
    );
  }

  Widget buildCards(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Card(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: AssetImage('img/morning1.jpg'),
                          fit: BoxFit.fill,
                        )),
                  ),
                  elevation: 32,
                  margin: EdgeInsets.fromLTRB(20, 50, 20, 40),
                  shape: StadiumBorder(),
                ),
                Align(
                  child: Text(
                    "أذكار الصباح",
                    style: TextStyle(
                        color: primaryColorShades,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        fontSize: 32),
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, '/evening_zekr'),
          ),
        ),
        Divider(
          height: 10,
          color: Color(0xFFFFC819),
        ),
        Expanded(
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Card(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: AssetImage('img/evening3.jpg'),
                          fit: BoxFit.fill,
                        )),
                  ),
                  elevation: 32,
                  margin: EdgeInsets.fromLTRB(20, 40, 20, 50),
                  shape: StadiumBorder(),
                ),
                Align(
                  child: Text(
                    "أذكار المساء",
                    style: TextStyle(
                        color: Color(0xFFFFC819),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        fontSize: 32),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/evening_zekr');
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => EveningZekr()),
//                    );
            },
          ),
        ),
      ],
    );
  }
}
