import 'package:emsakia/Models/Doaa/DoaaContent.dart';
import 'package:emsakia/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'Models/Azkar/AzkarContent.dart';

class Doaa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoaaState();
}

class DoaaState extends State<Doaa> {
  Stream firebaseStream;

  List<DoaaContent> myDoaa = new List();

  @override
  void initState() {
    super.initState();
    firebaseStream = Firestore.instance.collection('doaa_test').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColorShades,
      ),
      body: Center(
        child: buildBody(),
      ),
//      backgroundColor: primaryColorShades,
    );
  }

  Widget buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        snapshot.data.documents.forEach((doc) {
          myDoaa.add(DoaaContent.fromSnapShot(doc));
        });
        return buildList();
      },
    );
  }

  Widget buildList() {
    print(myDoaa.length);
    return ListView.builder(
      itemCount: myDoaa.length,
      itemBuilder: (context, index) {
        return buildItem(index);
      },
    );
  }

  Widget buildItem(int index) {
    return Stack(
      children: <Widget>[
        Container(
          child: Card(
            elevation: 10,
            child: Container(
//              color: Colors.red,
              padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
              child: Text(
                myDoaa[index].title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC819),
                ),
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
              decoration: BoxDecoration(
//                image: DecorationImage(image: AssetImage('img/doaa.jpg'), fit: BoxFit.fill),
              ),
            ),
            color: primaryColorShades,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 4, 20, 20, 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
        ),
        Container(
          child: Card(
            elevation: 20,
            color: Colors.greenAccent,
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () => print("Copied to Clipboard")),
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () => print("favorite")),
                  ),
                ],
              ),
            ),
            shape: CircleBorder(),
          ),
          margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
        ),
      ],
    );
  }
}
