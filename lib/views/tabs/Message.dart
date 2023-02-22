import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../config/config.dart';
import 'package:fsapp/config/size_fit.dart';

class Message extends StatefulWidget {
  Message({Key key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {

  int _pageNum = 1;
  int _count = 1;
  List _dataList = new List();
  bool _isEmpty = false;
  _ininGetList(){
    Http.post('/Info/getMessageList', params: {
      'pageNum':_pageNum,
      'pageSize':Config.pageSize
    }).then((value){
      print(value);
      setState(() {
        _dataList = value['data']['list'];
        _count = value['data']['count'];
      });
      if(_dataList.length==0){
        setState(() {
          _isEmpty = true;
        });
      }
    });
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  _onRefresh() async{
    setState(() {
      _pageNum =1;
    });
    Http.post('/Info/getMessageList', params: {
      'pageNum':_pageNum,
      'pageSize':Config.pageSize
    }).then((value){
      print(value);
      setState(() {
        _dataList = value['data']['list'];
        _count = value['data']['count'];
      });
      if(_dataList.length>0){
        setState(() {
          _isEmpty = false;
        });
      }
    });
    _refreshController.refreshCompleted();
    print('下拉刷新');
  }

  _onLoading() async{
    print('上拉加载');
    setState(() {
      _pageNum +=1;
    });
    print('总页数$_count');
    print('当前页数$_pageNum');
    if(_pageNum<=_count){
      Http.post('/Info/getMessageList', params: {
        'pageNum':_pageNum,
        'pageSize':Config.pageSize
      }).then((value){
//        print(value);
        setState(() {
          _dataList.addAll(value['data']['list']);
        });
      });
    }
    _refreshController.loadComplete();
  }


  _alertDialog() async{
    var res = await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('提示信息'),
            content: Text('将所有的消息标记为已读'),
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
                  Http.post('/Info/setAllMessageRead').then((res){
                    print(res);
                    if(res['code'] == 200){
                      _onRefresh();
                      Navigator.pop(context, 'success');
                    }else{
                      Fluttertoast.showToast(
                        msg: res['desc']
                      );
                      Navigator.pop(context, 'success');
                    }
                  });
                },
              )
            ],
          );
        }
    );

    print(res);
  }
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    _ininGetList();
  }
  @override
  Widget build(BuildContext context) {
    SizeFit.initialize();
    return  Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title:Text(
              '消息',
              style: TextStyle(
                  fontSize: 18.0
              ),
            ),
            centerTitle: true,//标题居中显示
            backgroundColor:Color.fromRGBO(31,112,250,1),
            leading: Text(''),
            actions: <Widget>[
              IconButton(//右侧内容
                icon: Image.asset('images/qingli.png',
                    width: 20.rpx,height: 20.rpx),
                onPressed: (){
                  _alertDialog();
                },
              ),
            ],
          ),
          preferredSize: Size.fromHeight(50.0)
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          waterDropColor:Config.themeColor,
          complete: Text('刷新成功',style: TextStyle(
              fontSize: Config.f15,
              color: Config.themeColor
          ),),
        ),
        footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              return Container(
                height: 55.0,
                child: Center(child:Text(_pageNum>_count?'没有更多数据了':'加载中...',style: TextStyle(
                    fontSize: Config.f15,
                    color: Config.themeColor
                ),) ,),
              );
            }
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _isEmpty==false?ListView(
          children: _dataList.map((value){
            return Container(
              constraints: BoxConstraints(
                minHeight: 70.rpx
              ),
              decoration:BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.5.rpx,
                          color: Color.fromRGBO(229, 227, 229, 1)
                      )
                  )
              ),
              child: InkWell(
                onTap: (){
//                Navigator.pushNamed(context, '/MessageDetail');

                  Http.post('/Info/setMessageRead', params: {
                    'id':value['noticeId']
                  }).then((res){
                    print(res);
                    if(res['code'] == 200){
                      setState(() {
                        value['status'] = '0';
                      });
                    }
                  });
                },
                child: ListTile(
                    leading: Image.asset(
                      value['noticeType']=='1'?'images/yujin.png':(value['noticeType']=='2'?'images/tongzhi.png':'images/jinji.png'),
                      width: 52.rpx,
                      height: 52.rpx,
                      fit: BoxFit.cover,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(value['noticeTypeStr'],
                              style: TextStyle(
                                  fontSize: Config.f15,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            value['status'] == '1'?Container(
                              margin: EdgeInsets.fromLTRB(5.rpx, 0, 0, 0),
                              width: 8.rpx,
                              height: 8.rpx,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.rpx),
                                color: Colors.red,
                              ),
                            ):Text(''),
                          ],
                        ),
                        Text(
                          value['createTimeStr'],
                          style: TextStyle(
                              fontSize: Config.f15,
                              color: Color.fromRGBO(153, 153, 153, 1)
                          ),

                        )
                      ],
                    ),
                    subtitle:Text(
                      value['noticeTitle'],
                      style: TextStyle(
                          fontSize: Config.f13,
                          color: Color.fromRGBO(153, 153, 153, 1)
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ),
              ),
            );
          }).toList(),
        ):Container(
          child: Center(child: Image.asset('images/noData.png')),
        )
      ),
    );
  }
}