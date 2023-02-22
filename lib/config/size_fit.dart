import 'dart:ui';
// import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';

import '../local.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SizeFit {
  // 1.基本信息
  static double physicalWidth;
  static double physicalHeight;
  static double screenWidth;
  static double screenHeight;
  static double dpr;
  static double statusHeight;
  static double bottomHeight;

  static double changeFontSize;

  static double rpx;
  static double px;

  static const double designWidth = 375;

  static void initialize({double standardSize = designWidth}) {

//    SpUtil.putDouble('fontSetting',fontSetting);
    // 1.手机的物理分辨率
    physicalWidth = window.physicalSize.width;
    physicalHeight = window.physicalSize.height;

    // 2.获取dpr
    dpr = window.devicePixelRatio;

    // 3.宽度和高度
    screenWidth = physicalWidth / dpr;
    screenHeight = physicalHeight / dpr;

    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    // 4.状态栏高度
    statusHeight = window.padding.top / dpr;

    // 5.计算rpx的大小
    rpx = screenWidth / standardSize;
    px = screenWidth / standardSize;

    // 6.底部高度
    bottomHeight = window.padding.bottom;

  }

  static double getWidth(){
    return screenWidth;
  }

  static double getHeight(){
    return screenHeight;
  }

  static double setRpx(double size) {
    return rpx * size;
  }

  static double setPx(double size) {
    return px * size;
  }
}


extension DoubleFit on double {
  double get px {
    return SizeFit.setPx(this);
  }

  double get rpx {
    return SizeFit.setRpx(this);
  }
}

extension IntFit on int {
  double get px {
    double setSize =  SpUtil.getDouble('fontSetting') ==0.0?0.9:SpUtil.getDouble('fontSetting');
    print('全局字体${SpUtil.getDouble('fontSetting')}');
    print('size$setSize');
    return SizeFit.setPx(this.toDouble() * setSize);
  }

  double get rpx {
    return SizeFit.setRpx(this.toDouble());
  }
}


