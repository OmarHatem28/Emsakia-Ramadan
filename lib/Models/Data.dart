import 'package:emsakia/Models/Date.dart';
import 'package:emsakia/Models/Timing.dart';

class Data {
  Timings timings;
  Date date;

  Data({this.timings, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    timings =
    json['timings'] != null ? new Timings.fromJson(json['timings']) : null;
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timings != null) {
      data['timings'] = this.timings.toJson();
    }
    if (this.date != null) {
      data['date'] = this.date.toJson();
    }
    return data;
  }
}