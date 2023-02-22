import 'package:flutter/material.dart';
import 'dart:math';
import 'size_fit.dart';

class Config {

  static final f13 = 13.px;
  static final f15 = 15.px;
  static final f17 = 17.px;
  static final f19 = 19.px;
  static final f21 = 21.px;
  static final f23 = 23.px;


  static const String baseUrl = "http://sishiersuogm.dev.hbbeisheng.com/api";
  static const String webUrl = "http://sishiersuogm.dev.hbbeisheng.com";

//    static const String baseUrl = "http://10.254.10.61:8005/api";
//    static const String webUrl = "http://10.254.10.61:8005";


  static const int timeout = 10000;
  static final pageSize = 10;
  static final themeColor = Color.fromRGBO(31,112,250,1);
  static final groupTableColor = HexColor('F2F2F7');
  static final separatorColor = HexColor('#EBEBEB');
  static final placeHolderColor = HexColor('000019',alpha: 0.22);
  static final subTextColor = HexColor('8D8D8D');

  static final color_0 = Colors.black;
  static final color_1 = HexColor('555555');
  static final color_2 = Colors.grey;
  static final color_3 = HexColor('#AAAAAA');
  static final color_4 = Colors.white;
  static final color_5 = Colors.transparent;

  static String tempImgUrlWithSize(int width,int height){
    return 'http://via.placeholder.com/${width}x$height';
  }

  static Color randomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
    if (r == 0 || g == 0 || b == 0) return Colors.black;
    if (a == 0) return Colors.white;
    return Color.fromARGB(
      a,
      r != 255 ? r : Random.secure().nextInt(r),
      g != 255 ? g : Random.secure().nextInt(g),
      b != 255 ? b : Random.secure().nextInt(b),
    );
  }

  static  bool isChinaPhoneLegal(String str) {
    return new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(str);
  }


}

/// 颜色创建方法
/// - [colorString] 颜色值
/// - [alpha] 透明度(默认1，0-1)
///
/// 可以输入多种格式的颜色代码，如: 0x000000,0xff000000,#000000
// ignore: non_constant_identifier_names
Color HexColor(String colorString, {double alpha = 1.0}) {
  String colorStr = colorString;
// colorString未带0xff前缀并且长度为6
  if (!colorStr.startsWith('0xff') && colorStr.length == 6) {
    colorStr = '0xff' + colorStr;
  }
// colorString为8位，如0x000000
  if(colorStr.startsWith('0x') && colorStr.length == 8) {
    colorStr = colorStr.replaceRange(0, 2, '0xff');
  }
// colorString为7位，如#000000
  if(colorStr.startsWith('#') && colorStr.length == 7) {
    colorStr = colorStr.replaceRange(0, 1, '0xff');
  }
// 先分别获取色值的RGB通道
  Color color = Color(int.parse(colorStr));
  int red = color.red;
  int green = color.green;
  int blue = color.blue;
// 通过fromRGBO返回带透明度和RGB值的颜色
  return Color.fromRGBO(red, green, blue, alpha);
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
