import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreSingleton {
  static Stream _firebaseStream;

  static Stream getInstance() {
    return _firebaseStream;
  }

  FireStoreSingleton(){
    _firebaseStream = Firestore.instance.collection('ramadan_date').snapshots();
  }


}