import 'package:cloud_firestore/cloud_firestore.dart';

class AzkarContent {
  String description;
  String zekr;
  int index;
  int repeat;


  AzkarContent({this.description, this.zekr, this.index, this.repeat});

  AzkarContent.fromSnapShot(DocumentSnapshot ds) {
    description = ds.data['content']['description'];
    zekr = ds.data['content']['zekr'];
    index = ds.data['content']['index'];
    repeat = ds.data['content']['repeat'];
  }

}