
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import 'package:sp_util/sp_util.dart';
import '../components/MyAppBar.dart';
import '../../config/size_fit.dart';
import '../../config/config.dart';

class VoiceSetting extends StatefulWidget {
  @override
  _VoiceSettingState createState() => _VoiceSettingState();
}

class _VoiceSettingState extends State<VoiceSetting> {
  int _value;
  int _small = 1;
  int _medium  = 2;
  int _large = 3;

  void _handleRadioValueChanged(int value) {
    setState(() {
      print(value);
      _value = value;
    });
  }

  _getVoice(){
    Http.post('/Users/setUserVoice').then((value){
      print(value);
      setState(() {
        _value = int.parse(value['data']['vocieType']);
      });
    });
  }

  _setVoice(){
    Http.post('/Users/setUserVoice',params: {
      'vocieType':_value.toString()
    }).then((value){
      if(value['code'] == 200){
        Fluttertoast.showToast(
          msg: '设置成功',
        );
      }else{
        Fluttertoast.showToast(
          msg: value['desc'],
        );
      }
    });
  }

//  String _groupValue = '1';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVoice();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('声音设置', boxShadow: 0,leftIsExistence: true,fontColor: Colors.black,bgColor: Colors.white,),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 300.rpx,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('设备声音频率设置',style: TextStyle(
                      fontSize: (17.rpx))),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: _small,
                      activeColor: Config.themeColor,
                      groupValue: _value,
                      onChanged: _handleRadioValueChanged,
                    ),
                    Text('慢速',style: TextStyle(fontSize: 15.rpx),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value:_medium,
                      activeColor: Config.themeColor,
                      groupValue: _value,
                      onChanged: _handleRadioValueChanged,
                    ),
                    Text('标准', style: TextStyle(fontSize: 15.rpx))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: _large,
                      activeColor: Config.themeColor,
                      groupValue: _value,
                      onChanged: _handleRadioValueChanged,
                    ),
                    Text('快速',style: TextStyle(fontSize: 15.rpx))
                  ],
                ),
              ],
            ),
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
                    _setVoice();
                  },
                  child: Text('确认',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                  color: Config.themeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
