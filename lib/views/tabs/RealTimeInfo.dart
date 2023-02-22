import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fsapp/config/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';
import '../../config/config.dart';
import '../../config/size_fit.dart';


class RealTimeInfo extends StatefulWidget {
  @override
  _RealTimeInfoState createState() => _RealTimeInfoState();
}

class _RealTimeInfoState extends State<RealTimeInfo> with SingleTickerProviderStateMixin{

  TabController _tabController;
  ScrollController _scrollController;

  var _imgList = [];
  int _pageNum = 1;
  int _count = 1;
  List _dataList = new List();
  List _helpWordList = [];

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _getRotationChartList(){
    Http.post('/Info/getRotationChartList').then((value){
      print(value['data']);
      print('我被执行了多少次');
      setState(() {
        _imgList = value['data'];
      });
    });
  }


  _getHelpWordList(){
    Http.post('/Info/getHelpWordList').then((value){
      print('使用手册$value');
      setState(() {
        _helpWordList = value['data'];
      });
    });
  }

  _initGetList(){
    Http.post('/Info/getNewsList', params: {
      'pageNum':_pageNum,
      'pageSize':Config.pageSize
    }).then((value){
      print(value);
      setState(() {
        _dataList = value['data']['list'];
        _count = value['data']['count'];
      });
    });
  }

  _onRefresh() async{
    setState(() {
      _pageNum =1;
    });
    Http.post('/Info/getNewsList', params: {
      'pageNum':_pageNum,
      'pageSize':Config.pageSize
    }).then((value){
      print(value);
      setState(() {
        _dataList = value['data']['list'];
        _count = value['data']['count'];
      });
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
      Http.post('/Info/getNewsList', params: {
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
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {});
    _scrollController = ScrollController();
    _getRotationChartList();
    _getHelpWordList();
    _initGetList();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
//          width: 354.rpx,
            height: 163.rpx,
            padding: EdgeInsets.all(10.rpx),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.rpx),
                )
            ),
          child: _imgList.length>0?Swiper(
          autoplay: true,
          autoplayDelay: 5000,
//            duration: 2000,
          itemBuilder: (BuildContext context, int index){
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.rpx),
              child: Image.network(
                '${Config.webUrl}${_imgList[index]['imageUrl']}',
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: _imgList.length,
          pagination: SwiperPagination(
              margin: EdgeInsets.all(5.rpx),
              builder: DotSwiperPaginationBuilder(
                  size: 7.rpx,
                  activeSize: 8.rpx
              )
          )
//            control: SwiperControl(),
      ):Text('')
    ),
        Expanded(
          child: Scaffold(
            appBar: TabBar(
              indicatorSize:TabBarIndicatorSize.label,
              unselectedLabelColor:Colors.black45,
              labelColor:Config.themeColor,
              controller: _tabController,
              tabs: <Widget>[
                Tab(text:'健康知识'),
                Tab(text:'使用手册'),
              ],
            ),
            body:TabBarView(
              controller: _tabController,
              children: <Widget>[
                SmartRefresher(
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
                  child: ListView(
                    children: _dataList.map((e){
                      return InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/NewDetails', arguments: {
                            'newsId':e['id']
                          });
                        },
                        child: Container(
                            height: 100.rpx,
                            margin: EdgeInsets.fromLTRB(10.rpx, 10.rpx, 10.rpx, 0),
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10.rpx),
                                    child: ClipRRect(
                                      borderRadius:BorderRadius.circular(5.rpx),
                                      child: Image.network(e['imageUrl'],
                                        width: 82.rpx,
                                        height: 72.rpx,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        width: 230.rpx,
                                        child: Text(
                                          e['title'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: Config.f17,fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 135.rpx,

                                            child: Text('发布人：${e['createBy']}',style: TextStyle(
                                                fontSize: Config.f13,color: Colors.black45
                                            ),),
                                          ),
                                          Container(
                                            width: 90.rpx,
                                            child: Text(e['createTime'],style: TextStyle(
                                                fontSize: Config.f13,color: Colors.black45
                                            ),),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                      );
                    }).toList()
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(15.rpx, 0, 15.rpx, 0),
                  child: ListView(
                    children: _helpWordList.map((e){
                      return InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/UserBookDetail',arguments: {
                            'id':e['id']
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
//                                Image.asset('images/message_logo.png',width: 17.rpx,),
                                  Icon(Icons.assignment,color: Config.themeColor,size: 17,),
                                  SizedBox(width: 5.rpx,),
                                  Text(e['title'],style: TextStyle(fontSize: Config.f17),),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,color: Colors.black26,size: 14.rpx,)
                          ],
                        ),
                      );
                    }).toList()
                  ),
                )
              ],
            )
          ),
        )
      ],
    );
  }

}
