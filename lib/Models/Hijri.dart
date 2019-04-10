class Hijri {
  String date;
  String format;
  String day;
  List<String> holidays;

  Hijri(
      {this.date,
        this.format,
        this.day,
        this.holidays});

  Hijri.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    holidays = json['holidays'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['format'] = this.format;
    data['day'] = this.day;
    data['holidays'] = this.holidays;
    return data;
  }
}
