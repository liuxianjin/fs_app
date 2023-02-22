import 'package:flutter/material.dart';

class CounterStore extends ChangeNotifier{
  String _userId = '5';

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String _token = '';

  String get token => _token;

  set token(String value) {
    _token = value;
  }
}