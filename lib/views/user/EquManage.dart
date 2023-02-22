import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import 'package:sp_util/sp_util.dart';
import '../Tabs.dart';
import '../components/MyAppBar.dart';
import '../../config/config.dart';
import '../../config/size_fit.dart';

class EquManage extends StatefulWidget {


  @override
  _EquManageState createState() => _EquManageState();
}

class _EquManageState extends State<EquManage> {

  var _list;
  List _subList;
  _getDeviceList(){
    Http.post('/Device/getDeviceList').then((value){
      print('返回的设备列表${value}');
//      print(value['data'] is List);
      setState(() {
        _list = value['data']['nowDevice'];
        _subList = value['data']['listDevice'];
      });
      print(_subList);
    });
  }

  _getIndexDeviceInfo(){//获取设备信息
    Http.post('/Device/getIndexDeviceInfo').then((value){
      print('数据类型${value['data'] is String}');
      if(value['data'] is String == false){
        SpUtil.remove('deviceStatus');
        SpUtil.putString('_device', json.encode(value['data']));
        Navigator.pushNamed(context, '/Tabs');
      }else{
        SpUtil.putString('_device', 'null');
        SpUtil.putString('deviceStatus', 'null');
      }
    });
  }
  @override
      void initState() {
    // TODO: implement initState
    super.initState();
    _getDeviceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('设备管理',bgColor: Colors.white,fontColor: Colors.black,leftIsExistence: true,boxShadow:0),
      body:Container(
        padding: EdgeInsets.all(15.rpx),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _list==null?Text(''):Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('当前设备',style: TextStyle(fontSize: Config.f17),),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(10.rpx),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/EquDetail',arguments:{
                          'deviceId':_list['deviceId']
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ClipOval(
                            child: _list['imageUrl']!=''?Image.network(_list['imageUrl'],
                            width: 65.rpx,
                            height: 65.rpx,
                            fit: BoxFit.cover,
                            ):Image.asset('images/default.png',
                              width: 65.rpx,
                              height: 65.rpx,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.rpx,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(_list['userName'],style: TextStyle(fontSize: Config.f17),),
                                    SizedBox(width: 5.rpx,),
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(5.rpx)
                                      ),
                                      constraints:BoxConstraints(
                                          minWidth: 35.rpx
                                      ),
                                      child: Text(_list['relationsStr'],style: TextStyle(fontSize: Config.f13,color: Colors.white),),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.rpx,),
                                Text('IMEI：${_list['imei']}',style: TextStyle(fontSize: Config.f15,color: Colors.black26),),

                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  _list['stateStr']=='离线'?'images/lixian.png':'images/loging.png',
                                  width: 15.rpx,
                                  height: 15.rpx,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 5.rpx,),
                                Text(_list['stateStr'],style: TextStyle(fontSize: Config.f15),),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _subList==null?Text(''):Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30.rpx,),
                    _subList.length>0?Text('切换设备',style: TextStyle(fontSize: Config.f17),):Text(''),
                    Column(
                      children: _subList==null?Text(''):_subList.map((value){
                        return Card(
                          child: Container(
                            padding: EdgeInsets.all(10.rpx),
                            child: InkWell(
                              onTap: (){
//                                Navigator.pushNamed(context, '/EquDetail');
                                //切换设备的接口
                                Http.post('/Device/changeDevice',params: {
                                  'deviceId':value['deviceId'],
                                }).then((value){
                                  if(value['code']==200){
                                    _getDeviceList();
                                    _getIndexDeviceInfo();
                                    Fluttertoast.showToast(
                                      msg: '切换成功',
                                    );
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ClipOval(
                                    child: value['imageUrl']!=''?Image.network(value['imageUrl'],
                                      width: 65.rpx,
                                      height: 65.rpx,
                                      fit: BoxFit.cover,
                                    ):Image.asset('images/default.png',
                                      width: 65.rpx,
                                      height: 65.rpx,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.rpx,),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(value['userName'],style: TextStyle(fontSize: Config.f17),),
                                            SizedBox(width: 5.rpx,),
                                            Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(5.rpx)
                                              ),
                                              constraints:BoxConstraints(
                                                  minWidth: 35.rpx
                                              ),
                                              child: Text(value['relationsStr'],style: TextStyle(fontSize: Config.f13,color: Colors.white),),
                                            ),
                                          ],
                                        ),
                                        Text('IMEI：${value['imei']}',style: TextStyle(fontSize: Config.f15,color: Colors.black26),),

                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          value['stateStr']=='离线'?'images/lixian.png':'images/loging.png',
                                          width: 15.rpx,
                                          height: 15.rpx,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 5.rpx,),
                                        Text(value['stateStr'],style: TextStyle(fontSize: Config.f15),),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  ],
                ),
                SizedBox(height: 50.rpx,),
                AddEqu(),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class AddEqu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ButtonTheme(
        minWidth: 278.rpx,
        height: 47.rpx,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/DeviceAs');
          },
          child: Text('添加设备',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
          color: Config.themeColor,
        ),
      ),
    );
  }
}
