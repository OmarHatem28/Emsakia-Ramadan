import 'package:emsakia/Models/Doaa/DoaaData.dart';
import 'package:emsakia/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Doaa extends StatefulWidget {
  final List<DoaaData> myDoaa;

  Doaa(this.myDoaa);

  @override
  State<StatefulWidget> createState() => DoaaState();
}

class DoaaState extends State<Doaa> {
  Stream firebaseStream;
  BuildContext _scaffoldContext;

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
        child: buildList(),
      ),
//      backgroundColor: primaryColorShades,
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: widget.myDoaa.length,
      itemBuilder: (context, index) {
        _scaffoldContext = context;
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
                widget.myDoaa[index].doaa_data,
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: widget.myDoaa[index].doaa_data));
                          Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
                              content:
                                  Text("Copied Successfully To Clipboard"),
                            duration: Duration(seconds: 1),
                          ));
                        }),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () => print("Added To Favorite"),
//                        icon: favorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
//                        onPressed: () => setState(() { favorite = !favorite; } )
                    ),
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
