import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fsapp/config/bs_mob_share.dart';
import 'package:sp_util/sp_util.dart';
import '../components/MyAppBar.dart';
import '../../config/size_fit.dart';
import '../../config/config.dart';
import '../../config/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../local.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //  扫描二维码
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('登录', bgColor: Colors.white, boxShadow: 0,fontColor: Colors.black,
          rightContent:InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/Register');
            },
            child: Row(
              children: <Widget>[
                Text('注册', style: TextStyle(color: Config.themeColor,fontSize: Config.f17),),
                SizedBox(width: 20.rpx,)
              ],
            )
          ),),
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
  final _text = TextEditingController();
  final _pwd = TextEditingController();

  bool _validate = false;
  SharedPreferences prefs;
  @override
  void dispose() {
    _text.dispose();
    _pwd.dispose();
    super.dispose();
  }
  _local () async{
    prefs = await SharedPreferences.getInstance();
  }

  //  扫描二维码
//  Future scan() async {
//    try {
//      // 此处为扫码结果，barcode为二维码的内容
//      String barcode = (await BarcodeScanner.scan()) as String;
//      print('扫码结果: '+barcode);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.cameraAccessDenied) {
//        // 未授予APP相机权限
//        print('未授予APP相机权限');
//      } else {
//        // 扫码错误
//        print('扫码错误: $e');
//      }
//    } on FormatException{
//      // 进入扫码页面后未扫码就返回
//      print('进入扫码页面后未扫码就返回');
//    } catch (e) {
//      // 扫码错误
//      print('扫码错误: $e');
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _local();

  }
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
                controller: _text,
                autofocus:false,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                keyboardType:TextInputType.number,
                decoration: InputDecoration(
                    hintText:'请输入手机号码',
//                    errorText: _validate ? '请输入正确的手机号' : null,
                    icon: Image.asset(
                      'images/login_use.png',
                      width: 20.rpx,
                      height: 20.rpx,
                    ),
                    border:  OutlineInputBorder(
                        borderSide:BorderSide.none
                    ),
                )
            ),
            TextField(//密码
                obscureText: true,
                controller: _pwd,
                decoration: InputDecoration(
                    hintText:'请输入密码',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text('登录代表您同意',style: TextStyle(fontSize: Config.f15),),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/UserAgreement');
                        },
                        child:Text('《用户协议》',style: TextStyle(color: Config.themeColor,fontSize: Config.f15),),
                      )

                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/ForgetPwd');
                  },
                  child: Text('忘记密码',style: TextStyle(color: Config.themeColor,fontSize: Config.f15),),
                )
              ],
            ),
            SizedBox(height: 30.rpx,),
            ButtonTheme(
              minWidth: 278.rpx,
              height: 47.rpx,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                ),
                onPressed: (){
                  var isPhone = Config.isChinaPhoneLegal(_text.text);
                  if(isPhone == true){
                    setState(() {
                      _validate = false;
                    });
                    Http.post('/Login/login',params:{
//                  ?phone=18810210780&password=12345
                    'phone':_text.text,
                    'password':_pwd.text
                  }).then((res){
                    if(res['code'] == 200){
                      print(res['data']);
//                      print(res['data']['userId'] is String);
                      SpUtil.putString('userId', res['data']['userId'].toString());
                      SpUtil.putString('token', res['data']['token']);
                      SpUtil.putString('_device', 'null');
                      Navigator.of(context).pushReplacementNamed('/Tabs');
//                      Navigator.pushNamed(context, '/Tabs');
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
                child: Text('登录',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                color: Config.themeColor,
              ),
            ),
            SizedBox(height: 20.rpx,),
            Container(
              child: Text('其他登录方式',style:TextStyle(color: Colors.black26,fontSize: Config.f13)),
            ),
            InkWell(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.rpx,),
                    InkWell(
                        onTap: (){
                          BSMobShare bsShare = BSMobShare.getInstance();
                          // 初始化WX分享
                          bsShare.initWechat('wx402aad8f743639e3', 'cb364830a2a701fc1fbef4eb0ddd1503','');
                          // 调用分享 1、微信 2、微信朋友圈 3、QQ 4、QQ空间
                          // result 回调返回 Map<String, dynamic> ret;
                          // ret['desc'] 授权后获取的相关信息
                          int platform = 1;
                          print(">>>>>>>>>>>> ${platform}");
                          Fluttertoast.showToast(msg: '进入微信登录，并初始化完成');
                          bsShare.auth(platform, (ret) {
                            Fluttertoast.showToast(msg: '正在返回结果');
                            print("----------->>>>${ret['code']}__${ret['desc']}");
                            Fluttertoast.showToast(msg: ret['desc']);
                            if(ret['code'] =='200' ){
                              var data = json.decode(ret['desc']);
                              print('openid------------${data['openid']}');
                              Http.post('/Wx/wxLogin',params: {
                                'imageUrl':data['icon'],
                                'nickName':data['nickname'],
                                'openId':data['openid']
                              }).then((value){
                                if(value['code'] == 200){
                                  print(value['data']);
//                      print(res['data']['userId'] is String);
                                  SpUtil.putString('userId', value['data']['userId'].toString());
                                  SpUtil.putString('token', value['data']['token']);
                                  SpUtil.putString('_device', 'null');
                                  Navigator.of(context).pushReplacementNamed('/Tabs');
//                      Navigator.pushNamed(context, '/Tabs');
                                }else{
                                  Fluttertoast.showToast(
                                    msg: value['desc'],
                                  );
                                }
                              });

                            }else{
                              Fluttertoast.showToast(msg: '授权失败，请重试或使用其他登录方式');
                            }
                          });
                          // openid   nickname  icon

                        },
                        child: Image.asset('images/weixin_login.png',width: 35.rpx,)
                    ),
                    SizedBox(height: 10.rpx,),
                    Container(
                      child: Text('微信登录',style:TextStyle(color: Colors.black54,fontSize: Config.f13)),
                    ),
                  ],
                ),
              ),
            ),
//            RaisedButton(
//              child: Text('点我'),
//              onPressed: (){
////                scan();
//              },
//            )
          ],
        ),
      );
  }

}

