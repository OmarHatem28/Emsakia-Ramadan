import 'package:emsakia/Models/DateAndTime/Hijri.dart';

class Date {
  String readable;
  String timestamp;
//  Gregorian gregorian;
  Hijri hijri;

  Date({this.readable, this.timestamp, this.hijri});

  Date.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    hijri = json['hijri'] != null ? new Hijri.fromJson(json['hijri']) : null;
  }

  Date.fromSnapShot(Map<dynamic, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    hijri = json['hijri'] != null ? new Hijri.fromSnapShot(json['hijri']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readable'] = this.readable;
    data['timestamp'] = this.timestamp;
    if (this.hijri != null) {
      data['hijri'] = this.hijri.toJson();
    }
    return data;
  }
}
