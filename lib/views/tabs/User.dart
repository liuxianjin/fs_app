import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fsapp/config/dio.dart';
import '../../config/config.dart';
import 'package:fsapp/config/size_fit.dart';


class User extends StatefulWidget {
  User({Key key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Column(
       children: <Widget>[
         UserTop(),
         UserContent(),
       ],
    );
  }
}


class UserTop extends StatefulWidget {
  @override
  _UserTopState createState() => _UserTopState();
}

class _UserTopState extends State<UserTop> {
  var _imgUrl;
  String _tel = '';
  String _name = '';

  _getUserInfo(){
    Http.post('/Users/getUserInfo').then((value){
      print(value);
      setState(() {
        _imgUrl = value['data']['imageUrl'];
        _tel = value['data']['phone'];
        _name = value['data']['nickName']==""?'暂未设置昵称':value['data']['nickName'];
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
      height: 158.rpx,
      color: Config.themeColor,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/UserMessage');
                    },
                    child: ClipOval(
                      child: _imgUrl==''?Image.asset('images/default.png',
                        width: 65.rpx,
                        height: 65.rpx,
                        fit: BoxFit.cover,
                      ):Image.network(_imgUrl??'',
                        width: 65.rpx,
                        height: 65.rpx,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.rpx,),
                  Column(
                    mainAxisSize:MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_name,style: TextStyle(fontSize: Config.f21,color: Colors.white),),
                      Text(_tel,style: TextStyle(fontSize: Config.f17,color: Colors.white))
                    ],
                  )
                ],
              ),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/Settings');
                },
                child: Column(
                  children: <Widget>[
                    Image.asset('images/setting.png',width: 24.rpx,),
                    Text('设置',style: TextStyle(fontSize: Config.f15,color: Colors.white))
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20.rpx,),
          Image.asset('images/logo.png',width: 158.rpx,height: 28.rpx,)
        ],
      ),
    );
  }
}

class UserContent extends StatelessWidget {

  List list = [
    {
      "text":"设备管理",
      "url":"images/bind.png",
      "router":"",
    }
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/EquManage');
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 15.rpx, 0, 15.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/bind.png',width: 19.rpx,),
                      SizedBox(width: 20.rpx,),
                      Text('设备管理',style: TextStyle(fontSize: Config.f17)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 19.rpx,color: Colors.black26,)

                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/UserAgreement');
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 15.rpx, 0, 15.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/user_xieyi.png',width: 19.rpx,),
                      SizedBox(width: 20.rpx,),
                      Text('用户协议',style: TextStyle(fontSize: Config.f17)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 19.rpx,color: Colors.black26,)

                ],
              ),
            ),
          ),
          InkWell(
            onTap: ()=>Navigator.pushNamed(context, '/UpdateApp'),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 15.rpx, 0, 15.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/user_close.png',width: 19.rpx,),
                      SizedBox(width: 20.rpx,),
                      Text('固件升级',style: TextStyle(fontSize: Config.f17)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 19.rpx,color: Colors.black26,)

                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/ChangePwd');
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 15.rpx, 0, 15.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/user_pwed.png',width: 19.rpx,),
                      SizedBox(width: 20.rpx,),
                      Text('修改密码',style: TextStyle(fontSize: Config.f17)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 19.rpx,color: Colors.black26,)

                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/Feedback');
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 15.rpx, 0, 15.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/user_yijian.png',width: 19.rpx,),
                      SizedBox(width: 20.rpx,),
                      Text('意见反馈',style: TextStyle(fontSize: Config.f17)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 19.rpx,color: Colors.black26,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
