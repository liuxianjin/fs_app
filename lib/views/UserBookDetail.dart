import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fsapp/config/config.dart';
import 'package:fsapp/config/dio.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';

class UserBookDetail extends StatefulWidget {
  Map arguments;
  UserBookDetail({Key key, this.arguments }) : super(key: key);
  @override
  _UserBookDetailState createState() => _UserBookDetailState(arguments:this.arguments);
}

class _UserBookDetailState extends State<UserBookDetail> {
  Map arguments;
  String _html;
  var _data;
  _UserBookDetailState({this.arguments});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(arguments['id']);
    Http.post('/Info/getHelpWordDetail', params: {
      'id':arguments['id']
    }).then((value){
      print('帮助文档信息$value');
      if(value['code']==200){
        setState(() {
          _html = value['data']['content'];
          _data = value['data'];
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('使用手册',fontColor: Colors.white,leftIsExistence: true,),
      body: _data==null?Text(''): ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(15.rpx, 15.rpx, 15.rpx, 0),
              width: 230.rpx,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _data['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: Config.f19,fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10.rpx,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '发布人：${_data['createBy']}',
                        style: TextStyle(
                            fontSize: Config.f15,color:Colors.black26
                        ),
                      ),
                      Text(
                        _data['createTime'],
                        style: TextStyle(
                            fontSize: Config.f15,color:Colors.black26
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.rpx,),
                  Divider(
                    height: 1.rpx,
                  ),
                  Html(
                      data:_html??""
//                  data: "",+
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}
