import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emsakia/Models/Doaa/DoaaContent.dart';
import 'package:emsakia/main.dart';
import 'package:flutter/material.dart';

class DoaaCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DoaaCategoriesState();

}

class DoaaCategoriesState extends State<DoaaCategories> {
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
      appBar: AppBar(backgroundColor: primaryColorShades,),
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
        return Container(
          child: buildItem(index),
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
        );
      },
    );
  }

  Widget buildItem(int index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Card(
              elevation: 20,
              color: Color(0xFFFFC819),
              child: Container(
                height: MediaQuery.of(context).size.height / 50,
                width: MediaQuery.of(context).size.width / 50,
              ),
              shape: CircleBorder(),
            ),
            margin: EdgeInsets.only(top: 25),
          ),
          flex: 1,
        ),
        Expanded(
          child: Card(
            color: Colors.greenAccent,
            margin: EdgeInsets.only(top: 25),
            child: Text(
              myDoaa[index].title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
//                color: Color(0xFFFFC819),
                color: primaryColorShades
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: Container(
            child: Card(
              elevation: 20,
              color: Color(0xFFFFC819),
              child: Container(
                height: MediaQuery.of(context).size.height / 50,
                width: MediaQuery.of(context).size.width / 50,
              ),
              shape: CircleBorder(),
            ),
            margin: EdgeInsets.only(top: 25),
          ),
          flex: 1,
        ),
      ],
    );
  }

}