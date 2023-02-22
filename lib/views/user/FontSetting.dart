
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import '../components/MyAppBar.dart';
import '../../config/size_fit.dart';
import '../../config/config.dart';

class FontSetting extends StatefulWidget {
  @override
  _FontSettingState createState() => _FontSettingState();
}

class _FontSettingState extends State<FontSetting> {
  double _value = 1.0;
  double _small = 0.9;
  double _medium  = 1.0;
  double _large = 1.1;

  void _handleRadioValueChanged(double value) {
    setState(() {
      print(value);
      _value = value;
    });
  }

//  String _groupValue = '1';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(SpUtil.getDouble('fontSetting')!=0.0){
      print(SpUtil.getDouble('fontSetting'));
      double abc = double.parse(SpUtil.getDouble('fontSetting').toStringAsFixed(1));
      setState(() {
        _value = abc;
      });
    }else{
      _value = 1.0;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('字体大小', boxShadow: 0,leftIsExistence: true,fontColor: Colors.black,bgColor: Colors.white,),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 300.rpx,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('AgedCare', style: TextStyle(
                    fontSize: (15*_value).rpx
                  ),),
                  Text('预览字体大小',style: TextStyle(
                      fontSize: (15*_value).rpx)),
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
                    Text('小号',style: TextStyle(fontSize: 13.rpx),)
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
                    Text('大号',style: TextStyle(fontSize: 17.rpx))
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
                    print(_value);
                    SpUtil.putDouble('fontSetting', _value);
                    print(SpUtil.getDouble('fontSetting'));
                    Fluttertoast.showToast(
                      msg: '修改成功，重启程序后生效',
                    );
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
