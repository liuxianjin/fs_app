import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fsapp/config/config.dart';
import 'package:fsapp/config/dio.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';


class NewDetails extends StatefulWidget {
  Map arguments;
  NewDetails({Key key, this.arguments }) : super(key: key);
  @override
  _NewDetailsState createState() => _NewDetailsState(arguments:this.arguments);
}

class _NewDetailsState extends State<NewDetails> {
  Map arguments;
  String _html;
  var _data;
  _NewDetailsState({this.arguments});
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    print(arguments['newsId']);
    Http.post('/Info/getNewsDetail', params: {
      'newsId':arguments['newsId']
    }).then((value){
      print(value);
      if(value['code']==200){
        setState(() {
          _html = value['data']['newsContent'];
          _data = value['data'];
        });
      }
      print(_html);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('新闻详情',fontColor: Colors.white,leftIsExistence: true,),
      body:_data==null?Text(''):ListView(
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
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
