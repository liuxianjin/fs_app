import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // 异步读取

  static var saveStr;
  static var saveInt;
  static var getStr;
  static var getInt;
  static var clear;

  static void initStorage(){
    saveStr = (String key, String value) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
    };
    saveInt = (String key, int value) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(key, value);
    };
    getStr = (String key) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    };
    getInt = (String key) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    };
    clear = () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.clear();
    };
  }


}
