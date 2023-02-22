class HomeView {
  String _name;
  int _age;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  HomeView();

  HomeView.av(this._name, this._age);
}