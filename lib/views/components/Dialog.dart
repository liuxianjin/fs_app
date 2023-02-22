import 'package:flutter/material.dart';
import '../components/MyAppBar.dart';
import '../../config/size_fit.dart';
import '../../config/config.dart';

class Dialog extends StatefulWidget {
  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
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

  _alertDialog() async{
    var res = await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('提示信息'),
            content: Text('您确定要删除吗？'),
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
                  print('确定');
                  Navigator.pop(context, 'Ok');
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
            height: 222.rpx,
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){

                    },
                    child: Text('点击拨打110',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),
                SizedBox(height: 20.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){

                    },
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
  _toast() async{

  }




  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



