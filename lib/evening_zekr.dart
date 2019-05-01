import 'package:emsakia/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'Models/Azkar/AzkarContent.dart';

class EveningZekr extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EveningZekrState();
}

class EveningZekrState extends State<EveningZekr> {
  Stream firebaseStream;

  List<AzkarContent> myEveningZekr = new List();

  @override
  void initState() {
    super.initState();
    firebaseStream = Firestore.instance.collection('evening_zekr').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: buildBody(),
        heightFactor: 200,
      ),
      backgroundColor: primaryColorShades,
    );
  }

  Widget buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        snapshot.data.documents.forEach((doc) {
          myEveningZekr.add(AzkarContent.fromSnapShot(doc));
        });
        return buildSwiper();
      },
    );
  }

  Widget buildSwiper() {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            buildItem(index),
            Container(
              child: Align(
                child: Text(
                  "مرات التكرار:  " + myEveningZekr[index].repeat.toString(),
                  style: MyTextStyle.titles,
                  textDirection: TextDirection.rtl,
                ),
              ),
              margin: EdgeInsets.only(top: 50),
              color: primaryColorShades,
            ),
          ],
        );
      },
      itemCount: myEveningZekr.length,
      itemWidth: MediaQuery.of(context).size.width - 10,
      itemHeight: MediaQuery.of(context).size.height / 1.3,
      layout: SwiperLayout.TINDER,
    );
  }

  Widget buildItem(int index) {
    return Stack(
      children: <Widget>[
        Card(
          child: Image.asset(
            'img/azkar_image.jpg',
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height / 2,
            fit: BoxFit.fill,
          ),
          elevation: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height / 1.97,
          color: Color.fromRGBO(0, 0, 0, 0.7),
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Text(
                myEveningZekr[index].zekr,
                style: TextStyle(
                  color: Color(0xFFFFC819),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: 'Tajawal',
                ),
                textDirection: TextDirection.rtl,
              )),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Text(
                    myEveningZekr[index].description,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Tajawal',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
