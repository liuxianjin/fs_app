import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';
import '../../config/config.dart';
import 'city_model.dart';
import 'package:lpinyin/lpinyin.dart';
import '../components/MyAppBar.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';


class CitySelectRoute extends StatefulWidget {
  Map arguments;
  CitySelectRoute({Key key, this.arguments }) : super(key: key);

  static const routeName = 'city';

  @override
//  State<StatefulWidget> createState() {
//    return new _CitySelectRouteState();
//  }
  _CitySelectRouteState createState() => _CitySelectRouteState(arguments:this.arguments);

}

class _CitySelectRouteState extends State<CitySelectRoute> {

  Map arguments;
  _CitySelectRouteState({this.arguments});

  List<CityInfo> _cityList = List();
  List<CityInfo> _hotCityList = List();

  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";
  Location _location;
  String _city = '';
  String _locationCity = '';

  void requestPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final location = await AmapLocation.instance.fetchLocation();
      setState(() => _location = location);
      setState(() {
        _locationCity = _location.city;
      });
      SpUtil.putString('cityName', _location.city);
      setState(() {
        _city =SpUtil.getString('cityName');
      });
      await AmapLocation.instance.stopLocation();
    } else {
      if (await Permission.location.request().isGranted) {
        final location = await AmapLocation.instance.fetchLocation();
        setState(() => _location = location);
        setState(() {
          _locationCity = _location.city;
        });
        SpUtil.putString('cityName', _location.city);
        setState(() {
          _city =SpUtil.getString('cityName');
        });
        await AmapLocation.instance.stopLocation();
      }
    }
  }


  @override
  void initState() {
    super.initState();
    loadData();
    requestPermission();
  }

  void loadData() async {
    _hotCityList.add(CityInfo(name: "北京市", tagIndex: "#"));
    _hotCityList.add(CityInfo(name: "广州市", tagIndex: "#"));
    _hotCityList.add(CityInfo(name: "成都市", tagIndex: "#"));
    _hotCityList.add(CityInfo(name: "深圳市", tagIndex: "#"));
    _hotCityList.add(CityInfo(name: "杭州市", tagIndex: "#"));
    _hotCityList.add(CityInfo(name: "武汉市", tagIndex: "#"));
  
    //加载城市列表
    rootBundle.loadString('assets/china.json').then((value) {
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      list.forEach((value) {
        _cityList.add(CityInfo(name: value['name']));
      });
      _handleList(_cityList);
      setState(() {
        _suspensionTag = _hotCityList[0].getSuspensionTag();
      });
    });
  }

  void _handleList(List<CityInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin =
      PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "#" ? "热门城市" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildListItem(CityInfo model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "#" ? "热门城市" : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              SpUtil.putString('cityName', model.name);
              Navigator.pushNamed(context, '/Tabs');
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar('定位选择',leftIsExistence: true,fontColor: Colors.white,),
      body: Column(
        children: <Widget>[

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15.0),
            height: 50.0,
            child: InkWell(
            onTap: (){
              SpUtil.putString('cityName', arguments['name']);
              Navigator.pushNamed(context, '/Tabs');
            },
              child: Text("当前定位城市: ${_city==''?'定位中...':_city}")),
          ),
          Expanded(
              flex: 1,
              child: SafeArea(
                child: AzListView(
                  data: _cityList,
                  topData: _hotCityList,
                  itemBuilder: (context, model) => _buildListItem(model),
                  suspensionWidget: _buildSusWidget(_suspensionTag),
                  isUseRealIndex: true,
                  itemHeight: _itemHeight,
                  suspensionHeight: _suspensionHeight,
                  onSusTagChanged: _onSusTagChanged,
                  //showCenterTip: false,
                ),
              )
          ),
        ],
      ),
    );
  }
}