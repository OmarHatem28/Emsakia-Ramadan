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
//          print(doc.data);
          myEveningZekr.add(AzkarContent.fromSnapShot(doc));
        });
        return buildSwiper(myEveningZekr);
      },
    );
  }

  Widget buildSwiper(List<AzkarContent> myEveningZekr) {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return buildItem(index);
      },
      itemCount: myEveningZekr.length,
      itemWidth: MediaQuery.of(context).size.width - 10,
      itemHeight: MediaQuery.of(context).size.height,
      layout: SwiperLayout.TINDER,
    );
  }

  Widget buildItem(int index) {
    return Stack(
      children: <Widget>[
        Card(
          child: Image.asset('img/azkar_image.jpg'),
          elevation: 4,
          color: Colors.red,
        ),
        Align(
          child: Opacity(
            opacity: 0.8,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(10),
              child: Text(
                myEveningZekr[index].zekr,
                style: MyTextStyle.minorText,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
