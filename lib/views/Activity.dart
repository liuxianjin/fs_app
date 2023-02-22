import 'package:flutter/material.dart';
import 'package:fsapp/config/dio.dart';
import 'package:fsapp/config/size_fit.dart';
import 'package:fsapp/config/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../views/components/MyAppBar.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {

    int _pageNum = 1;
    int _count = 1;
    List _dataList = new List();
    bool _isEmpty = false;
    _initGetList(){
      Http.post('/Device/getDeviceTrajectoryList', params: {
        'pageNum':_pageNum,
        'pageSize':Config.pageSize
      }).then((value){
//      print(value);
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
    Http.post('/Device/getDeviceTrajectoryList', params: {
      "deviceId":4,
      'pageNum':_pageNum,
      'pageSize':Config.pageSize
    }).then((value){
//      print(value);
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
    setState(() {
      _pageNum +=1;
    });
    print('总页数$_count');
    print('当前页数$_pageNum');
    if(_pageNum<=_count == true){
      Http.post('/Device/getDeviceTrajectoryList', params: {
        "deviceId":4,
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
    print('上拉加载');
  }
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    _initGetList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('活动轨迹',leftIsExistence:true,fontColor: Colors.white,),
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
        child: _isEmpty?Container(
          child: Center(child: Image.asset('images/noData.png')),
        ):ListView(
          children: _dataList.map((item){
            return
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/TraceMap',arguments: {
                    'id':item['id']
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(

                          bottom: BorderSide(
                              width: 1.rpx,
                              color: Colors.black12
                          )
                      )
                  ),
                  padding: EdgeInsets.all(20.rpx),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset('images/a_lock.png',width: 15.rpx,),
                          SizedBox(width: 10.rpx,),
                          Text('时间：${item['currentTime']}',style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1),fontSize: Config.f15),),
                        ],
                      ),
                      SizedBox(height: 10.rpx,),
                      Row(
                        children: <Widget>[
                          Image.asset('images/a_loctaion.png',width: 15.rpx,),
                          SizedBox(width: 10.rpx,),
                          Expanded(
                            child: Text('地点：${item['address']}',
                                style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1),fontSize: Config.f15),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 19.rpx,color: Colors.black26)
                        ],
                      ),
                    ],
                  ),
                ),
              );
          }).toList(),
        ),
      ),
    );
  }
}
