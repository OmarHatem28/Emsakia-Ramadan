
class DoaaData {
  String doaa_data;
  int index;
  int repeat;


  DoaaData(this.doaa_data, this.index, this.repeat);

  DoaaData.fromJson(Map<dynamic, dynamic> json) {
    doaa_data = json['zekr_data'];
    index = json['index'];
    repeat = json['repeat'];
  }
}