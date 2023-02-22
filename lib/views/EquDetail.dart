import 'package:barcode_scan/model/scan_options.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/config.dart';
import 'package:fsapp/config/dio.dart';
import 'package:sp_util/sp_util.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class EquDetail extends StatefulWidget {
  Map arguments;
  EquDetail({Key key, this.arguments }) : super(key: key);
  @override
  _EquDetailState createState() => _EquDetailState(arguments:this.arguments);
}

class _EquDetailState extends State<EquDetail> {
  Map arguments;
  _EquDetailState({this.arguments});

  String _relationship = '0'; //关系
  String _sex = '0';
  var _time = '点击选择出生日期';
  List _list = [];

  TextEditingController _userName;
  TextEditingController _height;
  TextEditingController _weight;
  TextEditingController _emergencyContactPhone;
  TextEditingController _text;


  _showDataPicker() async {
    Locale myLocale = Localizations.localeOf(context);
    var picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1850),
        lastDate: DateTime.now(),
        locale: myLocale);
    setState(() {
      _time = picker == null ? _time : (picker.toString()).substring(0,10);
//      _time = picker.toString();
    });
  }

  var _imgPath;
  var _deviceData;
  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath= image;
    });
  }
  @override

  _getDetailSetting(){
    Http.post('/Device/getDeviceInfo',params: {
      'deviceId':arguments['deviceId']
    }).then((value){
      print('返回的数据${value}');
      setState(() {
        _deviceData = value['data'];
        _list = value['data']['hobbyList'];
        _sex = value['data']['sex'];
        _time = value['data']['age'];
        _userName =  new TextEditingController(text: value['data']['userName']);
        _height =  new TextEditingController(text: value['data']['height']);
        _weight =  new TextEditingController(text: value['data']['weight']);
        _emergencyContactPhone =  new TextEditingController(text: value['data']['emergencyContactPhone']);
        _text = new TextEditingController(text: value['data']['imei']);
      });
    });
  }

  List _likeList = List();

  _getLike(){
    _likeList = [];
    for(int i =0;i<_list.length;i++){
      if(_list[i]['isActive']!='0'){
        _likeList.add(_list[i]['value']);
      }
    }
    print(_likeList);
    return _likeList.join(',');
  }
  Widget _getImageUrl(){
    if(_imgPath==null){
      if( _deviceData ==null || _deviceData['imageUrl'] == ''){
        return Image.asset(
          'images/default.png',
          width: 50.rpx,
          height: 50.rpx,
          fit: BoxFit.cover,
        );
      }else{
        return ClipOval(
          child: Image.network(
            _deviceData['imageUrl'],
            width: 50.rpx,
            height: 50.rpx,
            fit: BoxFit.cover,
          ),
        );
      }
    }else{
      return ClipOval(
        child: Image.file(
          _imgPath,
          width: 50.rpx,
          height: 50.rpx,
          fit: BoxFit.cover,
        ),
      );
    }

  }
  //修改数据
  _upLoadImage() async {
    var isPhone = Config.isChinaPhoneLegal(_emergencyContactPhone.text);
    if(isPhone!=true ){
      Fluttertoast.showToast(
        msg: '请输入正确的手机号',
      );
    }else if(_weight.text =='' ||_userName.text=='' || _height.text ==''|| _emergencyContactPhone.text ==''){
      Fluttertoast.showToast(
        msg: '请完善以上信息再提交',
      );
    }else{
      FormData fileData = FormData.fromMap({
        "age": _time!='点击选择出生日期'?_time:'',
        "deviceId": arguments['deviceId'], //修改 的时候传
        "emergencyContactPhone": _emergencyContactPhone.text,//紧急联系人电话
        "height": _height.text,//int
//        "imei":_text.text,
        "hobby": _getLike(),//爱好 1，2，3，
        "imageUrl": _imgPath!=null ?await MultipartFile.fromFile(_imgPath.path):null,//
        "relations": _relationship,//int 关系[0亲人,1本人,2其他]
        "sex": _sex,//int 0/1   1 男
        "userName": _userName.text,
        "weight": _weight.text,//int
      });
      Http.post('/Device/bindDevice',data:fileData ).then((value) {
        print(value);
        if (value['code'] == 200) {
          Fluttertoast.showToast(
            msg: '修改成功',
          );
          SpUtil.putString('_device', 'null');
          Navigator.pushNamed(context, '/Tabs');
        } else {
          Fluttertoast.showToast(
            msg: value['desc'],
          );
        }
      });
    }
  }

  Future scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      var options = ScanOptions(
          strings: {
            "cancel": "取消",
            "flash_on": "开启闪光灯",
            "flash_off": "关闭闪光灯"
          }
      );
      var result = await BarcodeScanner.scan(options: options);
      print('扫码结果: ${result}');
//      print(result.type); // The result type (barcode, cancelled, failed)
      print(result.rawContent); // The barcode content
      setState(() {
        _text = TextEditingController(text: result.rawContent);
      });

//      print(result.format); // The barcode format (as enum)
//      print(result.formatNote);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // 未授予APP相机权限
        Fluttertoast.showToast(msg: '未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException{
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }


  void initState() {
    // TODO: implement initState
    print(arguments['deviceId']);
    super.initState();
    _getDetailSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar('设备管理', bgColor: Colors.white,
            fontColor: Colors.black,
            leftIsExistence: true,
            boxShadow: 0),
        body: GestureDetector(
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.fromLTRB(15.rpx, 0, 15.rpx, 0),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(239, 247, 253, 1),
                      borderRadius: BorderRadius.circular(10.rpx)
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10.rpx),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/EquDetail');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ClipOval(
                            child: _deviceData ==null ?Image.asset(
                              'images/default.png',
                              width: 65.rpx,
                              height: 65.rpx,
                              fit: BoxFit.cover,
                            ):_deviceData['imageUrl']==''?Image.asset(
                              'images/default.png',
                              width: 65.rpx,
                              height: 65.rpx,
                              fit: BoxFit.cover,
                            ):Image.network(
                              _deviceData['imageUrl'],
                              width: 65.rpx,
                              height: 65.rpx,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 5.rpx,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(_deviceData==null?'':_deviceData['userName'],
                                      style: TextStyle(fontSize: Config.f17),),
                                    SizedBox(width: 5.rpx,),
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(5.rpx)
                                      ),
                                      constraints: BoxConstraints(
                                          minWidth: 35.rpx
                                      ),
                                      child: Text(_deviceData==null?'':_deviceData['relationsStr'], style: TextStyle(
                                          fontSize: Config.f13,
                                          color: Colors.white),),
                                    ),
                                  ],
                                ),
                                Text('IMEI：${_deviceData==null?'':_deviceData['imei']}', style: TextStyle(
                                    fontSize: Config.f15, color: Colors.black26),),

                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  _deviceData==null?'':(_deviceData['stateStr'] !='在线'?'images/lixian.png':'images/loging.png'),
                                  width: 15.rpx,
                                  height: 15.rpx,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 5.rpx,),
                                Text(_deviceData==null?'':_deviceData['stateStr'], style: TextStyle(
                                    fontSize: Config.f15),),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.rpx,),
                Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('基本信息', style: TextStyle(
                          fontSize: Config.f17, color: Config.themeColor,)),
                        Container(
                          width: 30.rpx,
                          color: Config.themeColor,
                          height: 2.rpx,
                        ),

                      ],
                    )
                ),
                SizedBox(height: 10.rpx,),
                Container(//上传头像
                  height: 60.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('设备头像',style: TextStyle(fontSize: Config.f17),),
                      InkWell(
                          onTap: _openGallery,
                          child: _getImageUrl()
                      ),
                    ],
                  ),
                ),
//              Container( //Imei
//                height: 50.rpx,
//                decoration: BoxDecoration(
//                    border: Border(
//                        bottom: BorderSide(
//                          color: Colors.black12,
//                        )
//                    )
//                ),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text('设备IMEI码', style: TextStyle(fontSize: Config.f17),),
//                    Expanded(
//                      child: Container(
//                        child: TextField(
//                            style: TextStyle(
//                                fontSize: Config.f15
//                            ),
//                            controller: _text,
//                            textAlign: TextAlign.end,
//                            decoration: InputDecoration(
//                              border: OutlineInputBorder(
//                                  borderSide: BorderSide.none
//                              ),
//                            )
//                        ),
//                      ),
//                    ),
//                    Container(
//                      width: 30.rpx,
//                      child: InkWell(
//                          onTap: (){
//                            scan();
//                          },
//                          child: Image.asset('images/erweima.png',width: Config.f15,fit: BoxFit.cover,)
//                      ),
//                    )
//                  ],
//                ),
//              ),
                Container( //姓名
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('使用者姓名', style: TextStyle(fontSize: Config.f17),),
                      Expanded(
                        child: Container(
                          child: TextField(
                            style: TextStyle(
                              fontSize: Config.f15
                            ),
                            controller: _userName,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: _deviceData==null?'':_deviceData['userName'],
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container( //关系
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('关系', style: TextStyle(fontSize: Config.f17),),
                      Container(
                          width: 80.rpx,
                          alignment: Alignment.centerRight,
                          child: DropdownButton(
                            value: _relationship,
                            items: [
                              DropdownMenuItem(value: '0',child: Text('亲人',style: TextStyle(fontSize: Config.f15))),
                              DropdownMenuItem(value: '1',child: Text('本人',style: TextStyle(fontSize: Config.f15))),
                              DropdownMenuItem(value: '2',child: Text('其他',style: TextStyle(fontSize: Config.f15))),

                            ],
                            onChanged: (value) {
                              setState(() {
                                _relationship = value;
                              });
                              print(value);
                            },
                            underline: Container(height: 0,),
                          )
                      )
                    ],
                  ),
                ),
                Container( //性别
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('性别', style: TextStyle(fontSize: Config.f17),),
                      Container(
                          width: 80.rpx,
                          alignment: Alignment.centerRight,
                          child: DropdownButton(
                            value: _sex,
                            items: [
                              DropdownMenuItem(value: '0',
                                  child: Text(
                                      '女', style: TextStyle(fontSize: Config.f15))),
                              DropdownMenuItem(value: '1',
                                  child: Text(
                                      '男', style: TextStyle(fontSize: Config.f15))),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _sex = value;
                              });
                              print(value);
                            },
                            underline: Container(height: 0,),
                          )
                      )
                    ],
                  ),
                ),
                Container( //年龄
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('出生日期', style: TextStyle(fontSize: Config.f17),),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                child: Text(_time == null ? '点击选择出生日期' : _time,style: TextStyle(fontSize: Config.f15),),
                                onTap: () => _showDataPicker()
                            )
                        ),
                      )
                    ],
                  ),
                ),
                Container( //姓名
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('体重（kg）', style: TextStyle(fontSize: Config.f17),),
                      Expanded(
                        child: Container(
                          child: TextField(
//                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              inputFormatters: [
                                //只允许输入小数
                                WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                              ],
                              keyboardType:TextInputType.number,
                              style: TextStyle(
                                  fontSize: Config.f15
                              ),
                            controller: _weight,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: '必填',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container( //姓名
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('身高（cm）', style: TextStyle(fontSize: Config.f17),),
                      Expanded(
                        child: Container(
                          child: TextField(
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              keyboardType:TextInputType.number,
                              style: TextStyle(
                                  fontSize: Config.f15
                              ),
                            controller: _height,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: '必填',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container( //姓名
                  height: 50.rpx,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          )
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('紧急联系人电话', style: TextStyle(fontSize: Config.f17),),
                      Expanded(
                        child: Container(
                          child: TextField(
                              style: TextStyle(
                                  fontSize: Config.f15
                              ),
                            controller: _emergencyContactPhone,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: '必填',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container( //日常活动爱好
                  height: 50.rpx,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('日常活动爱好', style: TextStyle(fontSize: Config.f17),),
                      Text('（此项可多选）',
                        style: TextStyle(fontSize: Config.f15, color: Colors.black45),),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 5.0,
                  children: _list.map((value) {
                    return ButtonTheme(
                      minWidth: 80.rpx,
                      height: 30.rpx,
                      child: RaisedButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Color.fromRGBO(137, 180, 252, 1))
                        ),
                        onPressed: () {
                          if (value['isActive'] == '0') {
                            setState(() {
                              value['isActive'] = '1';
                            });
                          } else {
                            setState(() {
                              value['isActive'] = '0';
                            });
                          }
                        },
                        child: Text(value['text'], style: TextStyle(
                            color: value['isActive'] == '0' ? Colors.black26 : Colors
                                .white, fontSize: Config.f15)),
                        color: value['isActive'] == '0' ? Colors.white : Color.fromRGBO(
                            31, 112, 250, 1),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 50.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: () {
                      _upLoadImage();
                    },
                    child: Text('保存',
                        style: TextStyle(color: Colors.white, fontSize: Config.f15)),
                    color: Config.themeColor,
                  ),
                ),
                // DeviceAsDetail()
                SizedBox(height: 150.rpx,)
              ],
            ),
          ),
        )
    );
  }
}
