import 'package:flutter/material.dart';
import '../components/MyAppBar.dart';
import '../../config/size_fit.dart';
import '../../config/config.dart';
import 'package:sp_util/sp_util.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  _alertDialog() async{
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('设置', boxShadow: 0,leftIsExistence: true,fontColor: Colors.black,bgColor: Colors.white,),
      body: Container(
        padding: EdgeInsets.all(20.rpx),
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/FontSetting');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.rpx),
                    child: Row(
                      children: <Widget>[
                        Image.asset('images/font_size.png',width: 21.rpx,),
                        SizedBox(width: 5.rpx,),
                        Text('字体大小',style: TextStyle(fontSize: Config.f17,color: Colors.black45),)
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,size: 17.rpx,color: Colors.black45,)
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/VoiceSetting');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.rpx),
                    child: Row(
                      children: <Widget>[
                        Image.asset('images/say.png',width: 21.rpx,),
                        SizedBox(width: 5.rpx,),
                        Text('音效设置',style: TextStyle(fontSize: Config.f17,color: Colors.black45),)
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,size: 17.rpx,color: Colors.black45,)
                ],
              ),
            ),
            SizedBox(height: 250.rpx,),
            ButtonTheme(
              minWidth: 278.rpx,
              height: 47.rpx,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                ),
                onPressed: (){
                  _alertDialog();
                },
                child: Text('退出登录',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                color: Config.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
