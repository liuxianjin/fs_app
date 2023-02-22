import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import '../components/MyAppBar.dart';
import '../../config/config.dart';
import '../../config/size_fit.dart';

class UpdateApp extends StatefulWidget {
  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  double _progress = 0.01;
  int _time = 120;
  bool _flag = false;

  startTime(){
    setState(() {
      _flag = true;
    });
    const period = const Duration(seconds: 1);
    Timer.periodic(period, (timer) {
      setState(() {
        _time--;
      });
      print(_time);
      if(_time==30 ||_time==60 || _time==90){
        Http.post('/deviceOtaSuccess').then((value){
          if(value['code'] == 200){
            Fluttertoast.showToast(msg:'恭喜您，固件更新成功');
            timer.cancel();
            timer = null;
            setState(() {
              _flag = false;
            });
          }
        });
      }
      if (_time <=0) {
        //取消定时器，避免无限回调
        setState(() {
          _time = 60;
        });
        Fluttertoast.showToast(msg:'恭喜您，固件更新成功');
        timer.cancel();
        timer = null;
        setState(() {
          _flag = false;
        });
      }
    });
  }

  _updateApp(){
    Http.post('/Device/deviceOta').then((value){
      if(value['code']==200){
        startTime();
      }else{
        Fluttertoast.showToast(msg: value['desc']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _flag==false?Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('固件升级',bgColor: Colors.white,fontColor: Colors.black,leftIsExistence: true,boxShadow:0),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.rpx),
        child: Column(
          children: <Widget>[
            Image.asset('images/updata.png',width: 190.rpx,),
            SizedBox(height: 50.rpx,),
            Center(child: Text('注意:请确保设备电量充足，电量过低可能导致升级失败，升级时间可能较长，且升级过程中设备可能与程序断开连接，还请耐心等待！',style: TextStyle(fontSize: Config.f19,color: Colors.black26),)),
            SizedBox(height: 50.rpx,),
            Center(
              child: ButtonTheme(
                minWidth: 278.rpx,
                height: 47.rpx,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)
                  ),
                  onPressed: (){
                    _updateApp();
                  },
                  child: Text('立即升级',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                  color: Config.themeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ):Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('固件升级',bgColor: Colors.white,fontColor: Colors.black,leftIsExistence: false,boxShadow:0),
      body: Container(
        child:  Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Loading(indicator: BallPulseIndicator(), size: 40.0,color: Config.themeColor,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('正在升级中,请耐心等待...',style: TextStyle(color: Config.themeColor,fontSize: Config.f17),),
              ],
            )
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}
