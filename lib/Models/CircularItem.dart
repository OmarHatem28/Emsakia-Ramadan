
class CircularItem {

  String _name;
  String _img;

  CircularItem(this._name, this._img);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get img => _img;

  set img(String value) {
    _img = value;
  }


}