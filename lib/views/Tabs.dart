import 'package:flutter/material.dart';
import 'package:fsapp/config/config.dart';
import 'package:sp_util/sp_util.dart';
import 'tabs/Home.dart';
import 'tabs/Message.dart';
import 'tabs/Motion.dart';
import 'tabs/RealTimeInfo.dart';
import 'tabs/User.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';
import '../bs/bs.dart';

class Tabs extends StatefulWidget {
  final index;

  Tabs({Key key,this.index=0}) : super(key: key);

  @override
  _TabsState createState() => _TabsState(this.index);

}

class _TabsState extends State<Tabs> {
  int _currentIndex;
  _TabsState(index){
    this._currentIndex = index;
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

  _getAppBar(index){
    switch(index){
//      case 0 :
////        return   PreferredSize(
////          preferredSize:Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
////          child:SafeArea(
////            top: true,
////            child: Offstage(),
////          ),
////        );
////      break;
      case 3 :
        return MyAppBar('资讯',fontColor: Colors.white);
      break;
      case 1 :
        return MyAppBar('运动',fontColor: Colors.white);
      break;
//      case 2 :
//        return PreferredSize(
//            child: AppBar(
//                title:Text(
//                  '消息',
//                  style: TextStyle(
//                      fontSize: 18.0
//                  ),
//                ),
//                centerTitle: true,//标题居中显示
//                backgroundColor:Color.fromRGBO(31,112,250,1),
//              leading: Text(''),
//              actions: <Widget>[
//                IconButton(//右侧内容
//                  icon: Image.asset('images/qingli.png',
//                  width: 20.rpx,height: 20.rpx),
//                  onPressed: (){
//                    print('search');
//                  },
//                ),
//              ],
//            ),
//            preferredSize: Size.fromHeight(50.0)
//        );
//      break;
      case 4 :
//        return MyAppBar('个人中心');
        return MyAppBar('个人中心', boxShadow:0);
      break;
    }
  }
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
                    Text('最多可以关联6台设备',style: TextStyle(height: 2,fontSize:Config.f15),),
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
  List _pageList = [
    Home(),
    Motion(),
    Message(),
    RealTimeInfo(),
    User()
  ];
  @override
  Widget build(BuildContext context) {
    SizeFit.initialize();
    return Container(
       child: Scaffold(
         resizeToAvoidBottomInset: false,
        appBar:this._getAppBar(this._currentIndex)!= null ? this._getAppBar(this._currentIndex):null,
        body: this._pageList[this._currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: this._currentIndex,
          onTap: (int index){
            if(SpUtil.getString('deviceStatus')=='null'){
              Future.delayed(
                  Duration.zero,
                      (){
                    _alertDialog();
                  }
              );
            }else{
              print(index);
              setState(() {
                this._currentIndex = index;
              });
            }
          },
          iconSize: 25.rpx,//icon的大小
          fixedColor: Colors.blue,//选中的颜色
          unselectedItemColor:Color.fromRGBO(121, 121, 121, .8),
          type: BottomNavigationBarType.fixed,//配置底部的tabs可以有多个防止超出换行
          items: [
            BottomNavigationBarItem(
              icon:Image.asset(
                'images/home.png',
                width: 25.rpx,
                height: 25.rpx,
              ),
              activeIcon: Image.asset('images/homeActive.png',
                width: 25.rpx,
                height: 25.rpx,
              ),
              title: Text('首页')
            ),
            BottomNavigationBarItem(
                icon:Image.asset(
                  'images/motion.png',
                  width: 25.rpx,
                  height: 25.rpx,
                ),
                activeIcon: Image.asset('images/motionActive.png',
                  width: 25.rpx,
                  height: 25.rpx,
                ),
                title: Text('运动')
            ),
            BottomNavigationBarItem(
              icon:Image.asset(
                'images/message.png',
                width: 25.rpx,
                height: 25.rpx,
              ),
              activeIcon: Image.asset('images/messageActive.png',
                width: 25.rpx,
                height: 25.rpx,
              ),
              title: Text('消息')
            ),
            BottomNavigationBarItem(
                icon:Image.asset(
                  'images/assessment.png',
                  width: 25.rpx,
                  height: 25.rpx,
                ),
                activeIcon: Image.asset('images/assessmentActive.png',
                  width: 25.rpx,
                  height: 25.rpx,
                ),
                title: Text('资讯')
            ),
            BottomNavigationBarItem(
              icon:Image.asset(
                'images/my.png',
                width: 25.rpx,
                height: 25.rpx,
              ),
              activeIcon: Image.asset('images/myActive.png',
                width: 25.rpx,
                height: 25.rpx,
              ),
              title: Text('我的')
            ),
          ],
        ),
      ),
    );
  }
}