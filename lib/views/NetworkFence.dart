import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/config.dart';
import 'package:fsapp/config/dio.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:sp_util/sp_util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';
import 'package:loading/loading.dart';


class NetworkFence extends StatefulWidget {
  @override
  _NetworkFenceState createState() => _NetworkFenceState();
}

class _NetworkFenceState extends State<NetworkFence> {
  TextEditingController _distance;
  String _address = '';

  _getMap() {
    Http.post('/Map/getLocationList').then((value) {
      print(value);
    });
  }


  _getMapScope() {
    Http.post('/Device/getLocationScope').then((value) {
      print(value);
      if (value['code'] == 200) {
        _address = value['data']['address'];
        _distance = TextEditingController(text: value['data']['scope']);
      }
    });
  }

  _setMapScope() {
    Http.post('/Device/getLocationScope', params: {
      'scope': _distance.text
    }).then((value) {
      print(value);
      if (value['code'] == 200) {
        Fluttertoast.showToast(msg: '设置成功');
        Navigator.of(context).pushReplacementNamed('/NetworkFence');
      }
    });
  }

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

  bool _isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    _getMap();
    _getMapScope();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('电子围栏', leftIsExistence: true, fontColor: Colors.white,
        rightContent: Container(padding: EdgeInsets.fromLTRB(0, 0, 15.rpx, 0),
          child: InkWell(
              onTap: () {
                setState(() {
                  _isShow = !_isShow;
                });
              },
              child: Icon(Icons.add, size: 30.rpx,)
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: "${Config.webUrl}/api/Map/getCenterLocation?uid=${SpUtil.getString('userId')}",
            //JS执行模式 是否允许JS执行
            javascriptMode: JavascriptMode.unrestricted,
          ),
          _isShow == false ? Text('') : Container(
            padding: EdgeInsets.fromLTRB(15.rpx, 15.rpx, 15.rpx, 15.rpx),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.white,
                      spreadRadius: 5.0,
                      offset: Offset(3.0, 3.0)
                  ),
                ]
            ),
            height: 130.rpx,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text('中心地址：${_address}', maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Config.f15),)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('围栏范围：', style: TextStyle(fontSize: Config.f15),),
                        Container(
                          width: 80.rpx,
                          height: 30.rpx,
                          child: TextField(
                            controller: _distance,
                            inputFormatters: [WhitelistingTextInputFormatter
                                .digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text('公里', style: TextStyle(fontSize: Config.f15),),
                      ],
                    ),
                    ButtonTheme(
                      minWidth: 70.rpx,
                      height: 25.rpx,
                      child: RaisedButton(
                        child: Text('确定', style: TextStyle(fontSize: Config.f15,
                            color: Config.themeColor),),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Config.themeColor)
                        ),
                        onPressed: () {
                          _setMapScope();
                        },
                        elevation: 0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
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


