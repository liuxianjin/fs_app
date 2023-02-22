import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/MyAppBar.dart';
import '../../config/size_fit.dart';
import '../../config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('注册', bgColor: Colors.white, boxShadow: 0,fontColor: Colors.black,leftIsExistence: true,),
      body:GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },child: LoginBody()),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  final _tel = TextEditingController();
  final _code = TextEditingController();
  final _pwd = TextEditingController();

  bool _disable = false;
  int _time = 60;

  @override
  Widget build(BuildContext context) {
    SizeFit.initialize();
    return Container(
      height: SizeFit.screenHeight,
      padding:EdgeInsets.fromLTRB(20.rpx, 0, 20.rpx, 0) ,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              height: 164.rpx,
              child:Image.asset(
                'images/login_logo.png',
                width: 165.rpx,
                height: 30.rpx,
              )
          ),
          TextField(//手机号
              autofocus:false,
              controller: _tel,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType:TextInputType.number,
              decoration: InputDecoration(
                  hintText:'请输入手机号码',
                  icon: Image.asset(
                    'images/login_use.png',
                    width: 20.rpx,
                    height: 20.rpx,
                  ),
                  border:  OutlineInputBorder(
                      borderSide:BorderSide.none
                  )
              )
          ),
          Row(
            children: <Widget>[
              Container(
                width: 220.rpx,
                child: TextField(//验证码
                    controller: _code,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType:TextInputType.number,
                    decoration: InputDecoration(
                        hintText:'请输入验证码',
                        icon: Image.asset(
                            'images/login_lock.png',
                            width: 20.rpx,
                            height: 20.rpx
                        ),
                        border:  OutlineInputBorder(
                            borderSide:BorderSide.none
                        )
                    )
                ),
              ),
              ButtonTheme(
                height: 30.rpx,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: Config.themeColor)
                  ),
                  onPressed: (){
                    if(!_disable){
                      Http.post('/Login/getCode',params: {
                        'phone':_tel.text,
                        'type':1
                      }).then((value){
                        if(value['code']==200){
                          Fluttertoast.showToast(msg: '验证码发送成功，请注意查收');
                          setState(() {
                            _disable = true;
                          });
                          const period = const Duration(seconds: 1);

                          Timer.periodic(period, (timer) {
                            setState(() {
                              _time--;
                            });
                            if (_time <=0) {
                              //取消定时器，避免无限回调
                              timer.cancel();
                              timer = null;
                              setState(() {
                                _disable = false;
                              });
                            }
                          });

                        }else{
                          Fluttertoast.showToast(msg: value['desc']);
                        }
                      });
                    }else{
                      Fluttertoast.showToast(msg: '请不要重复操作哦');
                    }
                  },
                  elevation:0,
                  child: _disable!=false?Text('${_time}后重新发送',style: TextStyle(color: Colors.black45,fontSize: Config.f13),):Text('获取验证码',style: TextStyle(color: Config.themeColor,fontSize: Config.f13)),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          TextField(//密码
              obscureText: true,
              controller: _pwd,
              decoration: InputDecoration(
                  hintText:'请输入6-12位密码',
                  icon: Image.asset(
                      'images/login_lock.png',
                      width: 20.rpx,
                      height: 20.rpx
                  ),
                  border:  OutlineInputBorder(
                      borderSide:BorderSide.none
                  )
              )
          ),
          SizedBox(height: 100.rpx,),
          ButtonTheme(
            minWidth: 278.rpx,
            height: 47.rpx,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
              ),
              onPressed: (){
                var isPhone = Config.isChinaPhoneLegal(_tel.text);
                if(isPhone == true){
                  print('验证码${_code.text}');
                  Http.post('/Login/register',params:{
//                  ?phone=18810210780&password=12345
                    'phone':_tel.text,
                    'code':_code.text,
                    'password':_pwd.text
                  }).then((res){
                    print(res);
                    if(res['code'] == 200){
                      Fluttertoast.showToast(
                        msg: '注册成功',
                      );
                      Navigator.pushNamed(context, '/Login');
                    }else{
                      Fluttertoast.showToast(
                        msg: res['desc'],
                      );
                    }
                  }).catchError((err){});
                }else{
                  Fluttertoast.showToast(
                    msg: '请输入正确的手机号',
                  );
                }
              },
              child: Text('注册',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
              color: Config.themeColor,
            ),
          ),
          SizedBox(height: 30.rpx,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Text('注册代表您同意',style: TextStyle(fontSize: Config.f15),),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/UserAgreement');
                      },
                      child:Text('《用户协议》',style: TextStyle(color: Config.themeColor,fontSize: Config.f15),),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


