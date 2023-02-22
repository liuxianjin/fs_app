import 'package:flutter/material.dart';
import '../views/Tabs.dart';
import '../views/city/city_select.dart';
import '../views/progress.dart';
import '../views/user/Login.dart';
import '../views/user/Register.dart';
import '../views/user/ForgetPwd.dart';
import '../views/user/UserAgreement.dart';
import '../views/Activity.dart';
import '../views/user/ChangePwd.dart';
import '../views/user/UpdateApp.dart';
import '../views/user/UserMessage.dart';
import '../views/user/EquManage.dart';
import '../views/user/Feedback.dart';
import '../views/DeviceAs.dart';
import '../views/EquDetail.dart';
import '../views/MessageDetail.dart';
import '../views/newDetails.dart';
import '../views/user/VoiceSetting.dart';
import '../views/user/FontSetting.dart';
import '../views/user/Settings.dart';
import '../views/NetworkFence.dart';
import '../views/TraceMap.dart';
import '../views/Position.dart';
import '../views/UserBookDetail.dart';

//配置路由
final routes = {
  '/Tabs':(context) => Tabs(),
  '/city':(context, {arguments}) => CitySelectRoute(arguments:arguments),
  '/Login':(context) => Login(),
  '/Register':(context) => Register(),
  '/ForgetPwd':(context) => ForgetPwd(),
  '/UserAgreement':(context) => UserAgreement(),
  '/Activity':(context) => Activity(),
  '/ChangePwd':(context) => ChangePwd(),
  '/UpdateApp':(context) => UpdateApp(),
  '/progress':(context, {arguments}) => CircleProgressWidget(arguments:arguments),
  '/UserMessage':(context) => UserMessage(),
  '/EquManage':(context) => EquManage(),
  '/Feedback':(context) => Back(),
  '/DeviceAs':(context) => DeviceAs(),
  '/EquDetail':(context, {arguments}) => EquDetail(arguments:arguments),
  '/MessageDetail':(context) => MessageDetail(),
  '/Settings':(context) => Settings(),
  '/VoiceSetting':(context) => VoiceSetting(),
  '/FontSetting':(context) => FontSetting(),
  '/NewDetails':(context, {arguments}) => NewDetails(arguments:arguments),
  '/NetworkFence':(context) => NetworkFence(),
  '/TraceMap':(context, {arguments}) => TraceMap(arguments:arguments),
  '/Position':(context) => Position(),
  '/UserBookDetail':(context, {arguments}) => UserBookDetail(arguments:arguments),
  // '/search':(context, {arguments}) => SearchPage(arguments:arguments),
};

// ignore: missing_return, top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings){
    //统一处理
    final String name = settings.name;
    final Function pageContentBuilder = routes[name];
    if(pageContentBuilder != null){
      if(settings.arguments != null){
        print('路由拦截器');
        final Route route = MaterialPageRoute(
          builder: (context) =>
            pageContentBuilder(context, arguments:settings.arguments)
          );
        return route;
      }else{
        print('路由拦截器');
        final Route route = MaterialPageRoute(
          builder:(context)=>
          pageContentBuilder(context)
        );
        return route;
      }
    }
  };