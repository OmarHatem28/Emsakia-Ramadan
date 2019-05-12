import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emsakia/Models/Doaa/DoaaData.dart';

class DoaaContent {
  String title ="";
  int index =0;
  List<DoaaData> doaa_list = new List();


  DoaaContent(this.title, this.index, this.doaa_list);

  DoaaContent.fromSnapShot(DocumentSnapshot ds) {
    title = ds.data['title'];
    index = ds.data['index'];
    ds.data['zekr'].forEach((zekr) {
      doaa_list.add(DoaaData.fromJson(zekr));
    });
    print(doaa_list[0].doaa_data);
  }

}