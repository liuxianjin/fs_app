import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fsapp/config/config.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';


class TraceMap extends StatefulWidget {
  Map arguments;
  TraceMap({Key key, this.arguments }) : super(key: key);
  @override
  _TraceMapState createState() => _TraceMapState(arguments:this.arguments);
}

class _TraceMapState extends State<TraceMap> {
  Map arguments;
  _TraceMapState({this.arguments});

  int count = 2;

  startTime()  {
    const period = const Duration(seconds: 1);
    Timer.periodic(period, (timer) {
      setState(() {
        count--;
      });
      print(count);
      if (count <=0) {
        //取消定时器，避免无限回调
        timer.cancel();
        timer = null;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    print(arguments['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('轨迹地图',leftIsExistence: true,fontColor: Colors.white,),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: "${Config.webUrl}/api/Map/getLocationList?id=${arguments['id']}",
            //JS执行模式 是否允许JS执行
            javascriptMode: JavascriptMode.unrestricted,
          ),
          count>0?Container(
            child:  Column(
              mainAxisAlignment:  MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Loading(indicator: BallPulseIndicator(), size: 40.0,color: Config.themeColor,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('正在加载地图...',style: TextStyle(color: Config.themeColor,fontSize: Config.f17),),
                  ],
                )
              ],
            ),
            color: Colors.white,
          ):Text('')
        ],
      ),
    );
  }
}
