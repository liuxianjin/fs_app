import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fsapp/store/index.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'config/chinese_cupertino_localizations.dart';
import 'config/dio.dart';
import 'routes/index.dart';
import 'config/size_fit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:amap_core_fluttify/amap_core_fluttify.dart';
import 'local.dart';
import 'store/index.dart';
import 'package:sp_util/sp_util.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await AmapCore.init('87b49e117e8963cfef75795a8e9e29e4');
  }
  await SpUtil.getInstance();
  Storage.initStorage();
  Http.initHttp();
  runApp(
      ChangeNotifierProvider(
        create: (ctx) => CounterStore(),
        child: MyApp(),
      )
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeFit.initialize();
    return MaterialApp(
        localizationsDelegates: [
          ChineseCupertinoLocalizations.delegate, // 自定义的delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        locale: const Locale('zh'),
        // home: Tabs(),
        theme:new ThemeData(
            primaryColor: Color.fromRGBO(31,112,250,1)
        ),
        initialRoute: SpUtil.getString('token').length ==0 ?'/Login' :'/Tabs',//初始化时加载的路由
        debugShowCheckedModeBanner: false,//去掉debug图标
        onGenerateRoute:onGenerateRoute
    );
  }
}
