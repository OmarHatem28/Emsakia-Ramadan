import 'package:emsakia/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'Models/Azkar/AzkarContent.dart';

class Azkar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AzkarState();
}

class AzkarState extends State<Azkar> {
  Stream firebaseStream;

  List<AzkarContent> myAzkar = new List();

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
      body: buildBody(),
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
          myAzkar.add(AzkarContent.fromSnapShot(doc));
        });
        return buildSwiper(myAzkar);
      },
    );
  }

  Widget buildSwiper(List<AzkarContent> myAzkar) {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return buildItem(index);
      },
      itemCount: myAzkar.length,
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
              child: Text(myAzkar[index].zekr, style: MyTextStyle.minorText,),
            ),
          ),
        ),
      ],
    );
  }
}
