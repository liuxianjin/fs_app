import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import '../components/MyAppBar.dart';
import '../../config/config.dart';
import '../../config/size_fit.dart';

class ChangePwd extends StatefulWidget {
  @override
  _ChangePwdState createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  final _oldPwd = TextEditingController();
  final _newPwd  = TextEditingController();
  final _newPwdTrue = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('修改密码',bgColor: Colors.white,fontColor: Colors.black,leftIsExistence: true,boxShadow:0),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(20.rpx),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              TextField(//手机号
                  autofocus:false,
                  obscureText: true,
                  controller: _oldPwd,
                  decoration: InputDecoration(
                      hintText:'请输入原密码',
                      icon: Image.asset(
                        'images/user_pwd.png',
                        width: 20.rpx,
                        height: 20.rpx,
                      ),
                      border:  OutlineInputBorder(
                          borderSide:BorderSide.none
                      )
                  )
              ),
              TextField(//密码
                  obscureText: true,
                  controller: _newPwd,
                  decoration: InputDecoration(
                      hintText:'请输入6-12位新密码',
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
              TextField(//密码
                  obscureText: true,
                  controller: _newPwdTrue,
                  decoration: InputDecoration(
                      hintText:'请确认新密码',
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
              SizedBox(height: 150.rpx,),
              ButtonTheme(
                minWidth: 278.rpx,
                height: 47.rpx,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)
                  ),
                  onPressed: (){
                    print(_oldPwd.text);
                    print(_newPwd.text);

                    if(_newPwdTrue.text == _newPwd.text){
                      Http.post('/Login/updatePassword',params:{
//                  ?phone=18810210780&password=12345
                        'oldPassword':_oldPwd.text,
                        'newPassword':_newPwd.text
                      }).then((res){

                        print(res);
                        if(res['code'] == 200){
                          Fluttertoast.showToast(
                            msg: res['desc'],
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
                        msg: '两次输入的密码不一致',
                      );
                    }
                  },
                  child: Text('确认修改',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                  color: Config.themeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
