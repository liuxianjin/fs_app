import 'package:flutter/cupertino.dart';
import 'package:fsapp/store/userInfo.dart';

class UserViewModel extends ChangeNotifier{
  UserInfo _user;

  UserInfo get user => _user;

  set user(UserInfo value) {
    _user = value;
    notifyListeners();
  }
}