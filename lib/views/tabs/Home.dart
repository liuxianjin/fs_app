import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/GoToMap.dart';
import 'package:fsapp/config/dio.dart';
import 'package:fsapp/views/homeClass.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';
import '../../config/config.dart';
import 'package:fsapp/config/size_fit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//  _alertDialog() async{//全屏
//    showDialog(
//        context: context,
//        builder: (context){
//          return Container(
//            height: 100.rpx,
//            color: Colors.red,
//          );
//        }
//    );
//  }
//  _launchPhone() async {
//    const url = 'tel:17601290637';
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
  Location _location;
  bool _bindEqu = false;
  int _progress = 0;//电量
  String _phone;
  String _emergencyContactPhone;
  String _city = '';
  String _locationCity = '';
  HomeView homeView=new  HomeView();
  String _titleMsg = '刷新成功';

//  int _battery = 100;

  _alertDialog() async{
    var res = await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.rpx))),
            contentPadding:EdgeInsets.all(0),
            content: Container(
              height: 390.rpx,
              child:Column(
                children: <Widget>[
                  Image.asset(
                    'images/dialog_bg.png',
                    width: 390.rpx,
                  ),
                  Text('快去绑定设备吧',style: TextStyle(height: 2,fontSize:Config.f15),),
                  Text('让你时时刻刻关心老人！',style: TextStyle(height: 2,fontSize:Config.f15),),
                  SizedBox(height: 20.rpx,),
                  ButtonTheme(
                    minWidth: 200.rpx,
                    height: 40.rpx,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)
                      ),
                      onPressed: (){
                        //关联事件
                        Navigator.pushNamed(context, '/DeviceAs');
                      },
                      child: Text('立即关联',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                      color: Colors.blue,
                    ),

                  ),
                  SizedBox(height: 15.rpx,),
                  InkWell(
                    onTap: (){
                      _alertExitMessage();
//                      Navigator.pop(context);
                    },
                    child: Image.asset('images/dialog_close.png', width: 28.rpx,),
                  ),
                ],
              )
            ),
          );
        }
    );

    print(res);
  }
  _alertExitMessage() async{
    var res = await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.rpx))),
            title: Text('友情提示'),
            content: Text('退出登录将清除所有用户设置与信息，您确定要退出吗？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: (){
                  print('取消');
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: (){
                  SpUtil.clear();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
                },
              )
            ],
          );
        }
    );
    print(res);
  }

  _simpleDialog() async{
    var res = await showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: Text('选择内容'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: (){
                print('Option A');
                Navigator.pop(context, 'A');
              },
              child: Text('Option A'),
            ),
            Divider(),
            SimpleDialogOption(
              onPressed: (){
                print('Option B');
                Navigator.pop(context, 'B');
              },
              child: Text('Option B'),
            )
          ],
        );
      }
    );
    print(res);
  }
  _bottomDialog() async{
    var res = await showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: 130.rpx,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: ()=> launch("tel://$_phone"),
                    child: Text('点击拨打$_phone',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),
                SizedBox(height: 10.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: () => launch("tel://$_emergencyContactPhone"),
                    child: Text('点击拨打紧急联系人',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  _gotoMap(String lat,String lon) async{
    var res = await showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: 200.rpx,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){
                      MapUtil.gotoAMap(double.parse(lon),double.parse(lat));
                    },
                    child: Text('高德地图',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),
                SizedBox(height: 10.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){
                      MapUtil.gotoBaiduMap(double.parse(lon),double.parse(lat));
                    },
                    child: Text('百度地图',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),

                SizedBox(height: 10.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){
                      MapUtil.gotoTencentMap(double.parse(lon),double.parse(lat));
                    },
                    child: Text('腾讯地图',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  _getQuantity(){
    Http.post('/Device/getDeviceBattery',params: {
      'deviceId':'1',
      'uid':SpUtil.getString('userId'),
      'token':SpUtil.getString('token'),
    }).then((value){
      print(value['data']['battery']);
      setState(() {
        _progress = int.parse(value['data']['battery']);
      });
    });
  }
  _getSosList(){
    Http.post('/Device/getSosList',params: {
      'deviceId':'1',
    }).then((value){
      print(value['data']);
      setState(() {
      _phone = value['data']['phone'];
      _emergencyContactPhone = value['data']['emergencyContactPhone'];

      });
    });
  }

  var _device;

  _getMessage(){
    Http.post('/Info/getNotReadMessasge').then((value){
      if(value['code'] == 200){
        Fluttertoast.showToast(msg: '您有未读消息，请及时查看',);
      }
    });
  }
  _getIndexDeviceInfo(){//获取设备信息
    Http.post('/Device/getIndexDeviceInfo').then((value){
      print(value);
      if(value['data']!='[]'){
        SpUtil.remove('deviceStatus');
        SpUtil.putString('_device', json.encode(value['data']));
        _getDeciveDetail();
      }else{
        SpUtil.putString('_device', 'null');
        SpUtil.putString('deviceStatus', 'null');
        Future.delayed(
            Duration.zero,
                (){
              _alertDialog();
            }
        );
      }
    });
  }

  _getDeciveDetail() {
    if (SpUtil.getString('_device') != 'null') {
      SpUtil.remove('deviceStatus');
      setState(() {
        _device = json.decode(SpUtil.getString('_device'));
        _progress = int.parse(_device['battery']);
      });
      _getSosList();
    }else{
      Future.delayed(
          Duration.zero,
              (){
            _alertDialog();
          }
      );
    }
  }
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  _onRefresh() async{
      Http.post('/Device/refreshDeviceCommonData',params: {
        'deviceId':_device['deviceId']
      }).then((value){
        if(value['code']==200){
          setState(() {
            _titleMsg = '刷新成功';
          });
          _getIndexDeviceInfo();
          _refreshController.refreshCompleted();
        }else{
          setState(() {
            _titleMsg = '刷新失败';
          });
          _refreshController.refreshCompleted();
          Fluttertoast.showToast(msg: value['desc']);
        }
      }).catchError((err){
        setState(() {
          _titleMsg = '刷新失败';
        });
        _refreshController.refreshCompleted();
      });
  }

  void requestPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final location = await AmapLocation.instance.fetchLocation();
      setState(() => _location = location);
      setState(() {
        _locationCity = _location.city;
      });
      SpUtil.putString('cityName', _location.city);
      setState(() {
        _city =SpUtil.getString('cityName');
      });
      await AmapLocation.instance.stopLocation();
    } else {
      if (await Permission.location.request().isGranted) {
        final location = await AmapLocation.instance.fetchLocation();
        setState(() => _location = location);
        setState(() {
          _locationCity = _location.city;
        });
        SpUtil.putString('cityName', _location.city);
        setState(() {
          _city =SpUtil.getString('cityName');
        });
        await AmapLocation.instance.stopLocation();
      }
    }
  }
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    _getMessage();
    //字体
    //初始化时 弹出弹出框 必须加上Future.delayed
    if (SpUtil.getString('_device') == 'null') {
      _getIndexDeviceInfo();
    }else{
      _getDeciveDetail();
    }

    if(SpUtil.getString('cityName') ==''){
      requestPermission();
    }else{
      setState(() {
        _city =SpUtil.getString('cityName');
      });
    }
  }
  Widget build(BuildContext context) {
    SizeFit.initialize();
//    return Container();
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: (){
            if(SpUtil.getString('deviceStatus')!='null'){
              Navigator.pushNamed(context, '/EquManage');
            }
          },
          child: Text(
              _device==null?'暂未绑定设备':_device['userName'],
              style: TextStyle(
              fontSize: Config.f17,
              color: Colors.white
            )
          ),
        ),
        elevation: 0,
        leading: RaisedButton(
          color: Colors.transparent,
          disabledColor: Colors.transparent,
//          onPressed: () {Navigator.pushNamed(context, '/EquManage');},
          elevation:0,
          child: Image.asset(
            'images/homeTopBind.png',
            width: 25.rpx,
            height: 25.rpx,
          )
        ),

        actions: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/city', arguments: {
                'name':_locationCity
              });
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/location.png',
                  width: 23.rpx,
                  height: 18.rpx,

                ),
                Text(
                  _city,
                  style: TextStyle(
                      fontSize: Config.f17,
                      color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15.rpx,)
        ],
      ),
      body:_device==null?Container(
        color: Config.themeColor,
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  width: 158.rpx,
                  height: 28.rpx,
                  fit: BoxFit.cover,
                ),
                Image.asset('images/homeShow.png',height:310.rpx,),
                Container(
//                          height: 220.rpx,
                    padding: EdgeInsets.all(15.rpx),
                    child: Wrap(
                      children: <Widget>[
                        Container(
                            width: 164.rpx,
                            height: 80.rpx,
                            decoration: BoxDecoration(
                                color:Color.fromRGBO(47,93,115,0.2),
                                borderRadius: BorderRadius.circular(5.rpx)
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:EdgeInsets.all(15.rpx),
                                    child: Image.asset(
                                      'images/majia.png',
                                      width: 25.rpx,
                                      height: 25.rpx,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.rpx,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '穿戴松紧',
                                        style: TextStyle(
                                            fontSize: Config.f15,
                                            color: Colors.white
                                        ),),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'images/loging.png',
                                            width: 12.rpx,
                                            height: 12.rpx,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            '暂无数据',
                                            style: TextStyle(
                                                fontSize: Config.f13,
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                        Container(
                            width: 164.rpx,
                            height: 80.rpx,
                            decoration: BoxDecoration(
                                color:Color.fromRGBO(47,93,115,0.2),
                                borderRadius: BorderRadius.circular(5.rpx)
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:EdgeInsets.all(15.rpx),
                                    child: Image.asset(
                                      'images/diedao.png',
                                      width: 25.rpx,
                                      height: 25.rpx,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.rpx,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '是否跌倒',
                                        style: TextStyle(
                                            fontSize: Config.f15,
                                            color: Colors.white
                                        ),),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'images/loging.png',
                                            width: 12.rpx,
                                            height: 12.rpx,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            '暂无数据',
                                            style: TextStyle(
                                                fontSize: Config.f13,
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                        Container(
                            width: 164.rpx,
                            height: 80.rpx,
                            decoration: BoxDecoration(
                                color:Color.fromRGBO(47,93,115,0.2),
                                borderRadius: BorderRadius.circular(5.rpx)
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:EdgeInsets.all(15.rpx),
                                    child: Image.asset(
                                      'images/shuju.png',
                                      width: 25.rpx,
                                      height: 25.rpx,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.rpx,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '触发功能',
                                        style: TextStyle(
                                            fontSize: Config.f15,
                                            color: Colors.white
                                        ),),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'images/loging.png',
                                            width: 12.rpx,
                                            height: 12.rpx,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            '左：暂无数据',
                                            style: TextStyle(
                                                fontSize: Config.f13,
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'images/loging.png',
                                            width: 12.rpx,
                                            height: 12.rpx,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            '左：暂无数据',
                                            style: TextStyle(
                                                fontSize: Config.f13,
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                        Container(
                            width: 164.rpx,
                            height: 80.rpx,
                            decoration: BoxDecoration(
                                color:Color.fromRGBO(47,93,115,0.2),
                                borderRadius: BorderRadius.circular(5.rpx)
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:EdgeInsets.all(15.rpx),
                                    child: Image.asset(
                                      'images/qinang.png',
                                      width: 25.rpx,
                                      height: 25.rpx,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.rpx,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '气囊状态',
                                        style: TextStyle(
                                            fontSize: Config.f15,
                                            color: Colors.white
                                        ),),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'images/loging.png',
                                            width: 12.rpx,
                                            height: 12.rpx,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "暂无数据",
                                            style: TextStyle(
                                                fontSize: Config.f13,
                                                color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                      ],
                    )
                )
              ],
            ),
          ],
        ),
      ):Container(
        color: Config.themeColor,
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: WaterDropHeader(
            waterDropColor:Colors.black26,
            complete: Text(_titleMsg,style: TextStyle(
                fontSize: Config.f15,
                color: Colors.white
            ),),
          ),
          onRefresh: _onRefresh,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/logo.png',
                                width: 158.rpx,
                                height: 28.rpx,
                                fit: BoxFit.cover,
                              ),
                            ),
//                      SizedBox(height: 20.rpx),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "${_device['stateStr'] =='离线' ? 'images/lixian.png':'images/loging.png'}",
                                  width: 12.rpx,
                                  height: 12.rpx,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 5.rpx,),
                                Text(
                                  _device==null?'':_device['stateStr'],
                                  style: TextStyle(
                                      fontSize: Config.f21,
                                      color: Colors.white
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 310.rpx,
                              child:Stack(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
//                              height: 310.rpx,
                                    child: _device['sexStr']=='女'?Image.asset('images/nvsheng.png',height:310.rpx,):Image.asset('images/homeShow.png',height:310.rpx,),
                                  ),
                                  Align(
                                      alignment: Alignment(0.95, -1),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              width: 45.rpx,
                                              height: 45.rpx,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(25.rpx)
                                                  )
                                              ),
                                              child: Center(
                                                child: InkWell(
                                                  onTap: (){
                                                    Navigator.pushNamed(context, '/progress',arguments:{
                                                      'bat':_device['battery']
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        '$_progress%',
                                                        style: TextStyle(
                                                            color: Colors.white,fontSize: 13.rpx
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 22.rpx,
                                                        height: 10.rpx,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Container(
                                                              width: 20.rpx,
                                                              height: 10.rpx,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(2.rpx),
                                                                  border: Border.all(
                                                                      color: Colors.white,
                                                                      width: 1.rpx
                                                                  )
                                                              ),
                                                              child: Container(
                                                                margin: EdgeInsets.fromLTRB(1.rpx, 1.rpx, (1+(20/100)*(100-_progress)).rpx, 1.rpx),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 2.rpx,
                                                              right: 0.rpx,
                                                              child: Container(
                                                                width: 3.rpx,
                                                                height: 5.rpx,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(1.rpx),
                                                                  color: Colors.white,
                                                                ),

                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ),
                                          Text('电量',style:TextStyle(color: Colors.white,fontSize: Config.f13))
                                        ],
                                      )
                                  ),
                                  Align(
                                      alignment: Alignment(0.95, -0.2),
                                      child:InkWell(
                                          onTap: (){
                                            this._bottomDialog();
                                          },
                                          child:  Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                width: 45.rpx,
                                                height: 45.rpx,
                                                child: Image.asset('images/sos.png'),
                                              ),
                                              Text('拨号',style:TextStyle(color: Colors.white,fontSize: Config.f13))
                                            ],
                                          )
                                      )
                                  ),
                                  Align(
                                      alignment: Alignment(0.95, 0.6),
                                      child: InkWell(
                                        onTap: (){
                                          if(_device['lat']!='' && _device['lon']!=''){
                                            _gotoMap(_device['lat'],_device['lon']);
                                          }else{
                                            Fluttertoast.showToast(msg: '暂无设备位置信息，无法规划路线');
                                          }
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              width: 45.rpx,
                                              height: 45.rpx,
                                              child: Image.asset('images/locationA.png'),
                                            ),
                                            Text('导航',style:TextStyle(color: Colors.white,fontSize: Config.f13))
                                          ],
                                        ),
                                      )
                                  ),

                                ],
                              ),
                            ),

                            Container(
//                          height: 220.rpx,
                                padding: EdgeInsets.all(15.rpx),
                                child: Wrap(
                                  children: <Widget>[
                                    Container(
                                        width: 164.rpx,
                                        height: 80.rpx,
                                        decoration: BoxDecoration(
                                            color:Color.fromRGBO(47,93,115,0.2),
                                            borderRadius: BorderRadius.circular(5.rpx)
                                        ),
                                        margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:EdgeInsets.all(15.rpx),
                                                child: Image.asset(
                                                  'images/majia.png',
                                                  width: 25.rpx,
                                                  height: 25.rpx,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 10.rpx,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '穿戴松紧',
                                                    style: TextStyle(
                                                        fontSize: Config.f15,
                                                        color: Colors.white
                                                    ),),
                                                  Row(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        _device['stateStr'] =='离线' ? 'images/lixian.png':(_device['tightnessStr']=='异常'?'images/yichang.png':'images/loging.png'),
                                                        width: 12.rpx,
                                                        height: 12.rpx,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        _device['stateStr'] =='离线' ? '离线':(_device==null?'':_device['tightnessStr']),
                                                        style: TextStyle(
                                                            fontSize: Config.f13,
                                                            color: Colors.white
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                    Container(
                                        width: 164.rpx,
                                        height: 80.rpx,
                                        decoration: BoxDecoration(
                                            color:Color.fromRGBO(47,93,115,0.2),
                                            borderRadius: BorderRadius.circular(5.rpx)
                                        ),
                                        margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:EdgeInsets.all(15.rpx),
                                                child: Image.asset(
                                                  'images/diedao.png',
                                                  width: 25.rpx,
                                                  height: 25.rpx,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 10.rpx,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '是否跌倒',
                                                    style: TextStyle(
                                                        fontSize: Config.f15,
                                                        color: Colors.white
                                                    ),),
                                                  Row(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        _device['stateStr'] =='离线' ? 'images/lixian.png':(_device['isFallStr']=='跌倒'?'images/yichang.png':'images/loging.png'),
                                                        width: 12.rpx,
                                                        height: 12.rpx,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        _device['stateStr'] =='离线' ? '离线':(_device==null?'':_device['isFallStr']),
                                                        style: TextStyle(
                                                            fontSize: Config.f13,
                                                            color: Colors.white
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                    Container(
                                        width: 164.rpx,
                                        height: 80.rpx,
                                        decoration: BoxDecoration(
                                            color:Color.fromRGBO(47,93,115,0.2),
                                            borderRadius: BorderRadius.circular(5.rpx)
                                        ),
                                        margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:EdgeInsets.all(15.rpx),
                                                child: Image.asset(
                                                  'images/shuju.png',
                                                  width: 25.rpx,
                                                  height: 25.rpx,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 10.rpx,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '触发功能',
                                                    style: TextStyle(
                                                        fontSize: Config.f15,
                                                        color: Colors.white
                                                    ),),
                                                  Row(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        _device['stateStr'] =='离线' ? 'images/lixian.png':(_device['fireLine1Str']=='异常'?'images/yichang.png':'images/loging.png'),
                                                        width: 12.rpx,
                                                        height: 12.rpx,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        '左：${_device['stateStr'] =='离线' ? '离线':( _device==null?'':_device['fireLine1Str'])}',
                                                        style: TextStyle(
                                                            fontSize: Config.f13,
                                                            color: Colors.white
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        _device['stateStr'] =='离线' ? 'images/lixian.png':(_device['fireLine2Str']=='异常'?'images/yichang.png':'images/loging.png'),
                                                        width: 12.rpx,
                                                        height: 12.rpx,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        '右：${_device['stateStr'] =='离线' ? '离线':(_device==null?'':_device['fireLine2Str'])}',
                                                        style: TextStyle(
                                                            fontSize: Config.f13,
                                                            color: Colors.white
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                    Container(
                                        width: 164.rpx,
                                        height: 80.rpx,
                                        decoration: BoxDecoration(
                                            color:Color.fromRGBO(47,93,115,0.2),
                                            borderRadius: BorderRadius.circular(5.rpx)
                                        ),
                                        margin: EdgeInsets.fromLTRB(0, 0, 5.rpx, 5.rpx),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(5.rpx, 5.rpx, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:EdgeInsets.all(15.rpx),
                                                child: Image.asset(
                                                  'images/qinang.png',
                                                  width: 25.rpx,
                                                  height: 25.rpx,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 10.rpx,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '气囊状态',
                                                    style: TextStyle(
                                                        fontSize: Config.f15,
                                                        color: Colors.white
                                                    ),),
                                                  Row(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        _device['stateStr'] =='离线' ? 'images/lixian.png':(_device['isGasBagStr']=='异常'?'images/yichang.png':'images/loging.png'),
                                                        width: 12.rpx,
                                                        height: 12.rpx,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        _device['stateStr'] =='离线' ? '离线':(_device==null?'':_device['isGasBagStr']),
                                                        style: TextStyle(
                                                            fontSize: Config.f13,
                                                            color: Colors.white
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                      _bindEqu==false?Container():Container(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  constraints:BoxConstraints(
                                    minHeight: 210.rpx,
                                  ),
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(20.rpx),
                                        child: InkWell(
                                            onTap:(){
                                              Navigator.pushNamed(context, '/DeviceAs');
                                            },
                                            child: Text('绑定新设备+',style: TextStyle(fontSize: Config.f19), )
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ],
                          )
//                  child: ,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
