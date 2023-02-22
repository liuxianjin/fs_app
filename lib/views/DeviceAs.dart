
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/config.dart';
import 'package:fsapp/config/dio.dart';
import 'package:fsapp/model/AddDevice.dart';
import 'package:sp_util/sp_util.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';


class DeviceAs extends StatefulWidget {
  @override
  _DeviceAsState createState() => _DeviceAsState();
}

class _DeviceAsState extends State<DeviceAs> {

  String _relationship = '0';//关系
  String _sex = '0';//性别
  var _time='点击选择出生日期';

  TextEditingController _text;

  final _userName = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _emergencyContactPhone = TextEditingController();

//  final _text = TextEditingController();

  String _deviceId;
  String _hobby;
  String _imageUrl;
  String _relations;
  String _token;
  String _uid;
  String _userId;

  List _list = [];
  List _likeList = List();
  AddDevice addData = new AddDevice();

  _getLikeList(){
    Http.post('/Info/getHobbyList').then((value){
      print('爱好列表$value');
      setState(() {
        _list = value['data'];
      });
    });
  }

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

  _showDataPicker() async {
    Locale myLocale = Localizations.localeOf(context);
    var picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1850),
        lastDate: DateTime.now(),
        locale: myLocale);
    setState(() {
      _time = picker == null ? '点击选择出生日期' : (picker.toString()).substring(0,10);
//      _time = picker.toString();
    });
  }


  var _imgPath;

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imgPath= image;
      });
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imgPath = image;
    });
  }

  //  扫描二维码
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
      print(result.rawContent); // The barcode content
      setState(() {
        _text = TextEditingController(text: result.rawContent);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
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

  //_height.text!=''
  //上传图片
  _upLoadImage() async {
    print(_text);
    var isPhone = Config.isChinaPhoneLegal(_emergencyContactPhone.text);
    if(isPhone!=true ){
      Fluttertoast.showToast(
        msg: '请输入正确的手机号',
      );
    }else if(_weight.text =='' ||_userName.text=='' || _height.text ==''|| _emergencyContactPhone.text =='' || _text.text ==''){
      Fluttertoast.showToast(
        msg: '请完善以上信息再提交',
      );
    }
    else{

      print(_userName);
      FormData fileData = FormData.fromMap({
        "age": _time!='点击选择出生日期'?_time:'',
        "emergencyContactPhone": _emergencyContactPhone.text,//紧急联系人电话
        "height": _height.text,//int
        "hobby": _getLike(),//爱好 1，2，3，
        "imageUrl": _imgPath==null?null:await MultipartFile.fromFile(_imgPath.path),//
        "relations": _relationship,//int 关系[0亲人,1本人,2其他]
        "sex": _sex,//int 0/1   1 男
        "imei": _text.text,
        "userName": _userName.text,
        "weight": _weight.text,//int
      });
      Http.post('/Device/bindDevice',data:fileData ).then((value){
        print(value);
        if(value['code']==200){
          Fluttertoast.showToast(
            msg: '绑定成功',
          );
          SpUtil.putString('_device', 'null');
          Navigator.pushNamed(context, '/Tabs');
        }else{
          Fluttertoast.showToast(
            msg: value['desc'],
          );
        }
      });
    }

  }


  _bottomDialog() async{
    var res = await showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: 120.rpx,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){
                      _takePhoto();
                    },
                    child: Text('拍照',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),
                SizedBox(height: 10.rpx,),
                ButtonTheme(
                  minWidth: 278.rpx,
                  height: 47.rpx,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (){
                      _openGallery();
                    },
                    child: Text('相册',style: TextStyle(color: Colors.white,fontSize: Config.f17)),
                    color: Config.themeColor,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _text = TextEditingController(text: '');
    });

    print('sssssssssssssssssssssssssssss${_text}');
    _getLikeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('设备关联',leftIsExistence: true,fontColor: Colors.white,),
      body: GestureDetector(
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB( 15.rpx, 0, 15.rpx, 0),
              child: Column(
                children: <Widget>[
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
                        Text('上传头像',style: TextStyle(fontSize: Config.f17),),
                        InkWell(
                            onTap: _openGallery,
                            child:_imgPath != null ?ClipOval(child: Image.file(_imgPath,width: 50.rpx,height: 50.rpx,fit: BoxFit.cover,)):
                            Image.asset('images/addImg.png',width:50.rpx,)
                        ),
                      ],
                    ),
                  ),
                  Container(//设备码
                    height: 50.rpx,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:BorderSide(
                              color: Colors.black12,
                            )
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('设备IMEI码',style: TextStyle(fontSize: Config.f17),),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: TextField(
                                style: TextStyle(
                                    fontSize: Config.f15
                                ),
                              controller: _text,
                              textAlign:TextAlign.end,
                              decoration: InputDecoration(
                                  hintText:'请输入设备IMEI码',
                                  border:  OutlineInputBorder(
                                      borderSide:BorderSide.none
                                  ),
                              )
                            ),
                          ),
                        ),
                        Container(
                          width: 30.rpx,
                          child: InkWell(
                            onTap: (){
                              scan();
                            },
                              child: Image.asset('images/erweima.png',width: Config.f15,fit: BoxFit.cover,)
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(//姓名
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
                        Text('使用者姓名',style: TextStyle(fontSize: Config.f17),),
                        Expanded(
                          child: Container(
                            child: TextField(
                                style: TextStyle(
                                    fontSize: Config.f15
                                ),
                                controller: _userName,
                                textAlign:TextAlign.end,
                                decoration: InputDecoration(
                                  hintText:'必填',
                                  border:  OutlineInputBorder(
                                      borderSide:BorderSide.none
                                  ),
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(//关系
                    height: 50.rpx,
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
                        Text('关系',style: TextStyle(fontSize: Config.f17),),
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
                            underline:Container(height: 0,),
                          )
                        )
                      ],
                    ),
                  ),
                  Container(//性别
                    height: 50.rpx,
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
                        Text('性别',style: TextStyle(fontSize: Config.f17),),
                        Container(
                            width: 80.rpx,
                            alignment: Alignment.centerRight,
                            child: DropdownButton(
                              value: _sex,
                              items: [
                                DropdownMenuItem(value: '0',child: Text('女',style: TextStyle(fontSize: Config.f15))),
                                DropdownMenuItem(value: '1',child: Text('男',style: TextStyle(fontSize: Config.f15))),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _sex = value;
                                });
                                print(value);
                              },
                              underline:Container(height: 0,),
                            )
                        )
                      ],
                    ),
                  ),
                  Container(//年龄
                    height: 50.rpx,
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
                        Text('出生日期',style: TextStyle(fontSize: Config.f17),),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: Text(_time == null ? '点击选择出生日期' : _time,style: TextStyle(
                                    fontSize: Config.f15
                                ),),
//                      child:Text('1111'),
                                onTap:() => _showDataPicker(),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(//姓名
                    height: 50.rpx,
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
                        Text('体重（kg）',style: TextStyle(fontSize: Config.f17),),
                        Expanded(
                          child: Container(
                            child: TextField(
                                style: TextStyle(
                                    fontSize: Config.f15
                                ),
                                controller:_weight,
                                inputFormatters: [
                                  //只允许输入小数
                                  WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                                ],
                                keyboardType:TextInputType.number,
                                textAlign:TextAlign.end,
                                decoration: InputDecoration(
                                  hintText:'必填',
                                  border:  OutlineInputBorder(
                                      borderSide:BorderSide.none
                                  ),
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(//姓名
                    height: 50.rpx,
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
                        Text('身高（cm）',style: TextStyle(fontSize: Config.f17),),
                        Expanded(
                          child: Container(
                            child: TextField(
                                style: TextStyle(
                                    fontSize: Config.f15
                                ),
                                controller:_height,
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                keyboardType:TextInputType.number,
                                textAlign:TextAlign.end,
                                decoration: InputDecoration(
                                  hintText:'必填',
                                  border:  OutlineInputBorder(
                                      borderSide:BorderSide.none
                                  ),
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(//姓名
                    height: 50.rpx,
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
                        Text('紧急联系人电话',style: TextStyle(fontSize: Config.f17),),
                        Expanded(
                          child: Container(
                            child: TextField(
                                style: TextStyle(
                                    fontSize: Config.f15
                                ),
                                controller:_emergencyContactPhone,
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                keyboardType:TextInputType.number,
                                textAlign:TextAlign.end,
                                decoration: InputDecoration(
                                  hintText:'必填',
                                  border:  OutlineInputBorder(
                                      borderSide:BorderSide.none
                                  ),
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(//日常活动爱好
                    height: 50.rpx,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('日常活动爱好',style: TextStyle(fontSize: Config.f17),),
                        Text('（此项可多选）',style: TextStyle(fontSize: Config.f15,color: Colors.black45),),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing:5.0,
                    children: _list.map((value){
                      return ButtonTheme(
                        minWidth: 80.rpx,
                        height: 30.rpx,
                        child: RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Color.fromRGBO(137, 180, 252, 1))
                          ),
                          onPressed: (){
                            if(value['isActive'] =='0'){
                              setState(() {
                                value['isActive'] = '1';
                              });
                            }else{
                              setState(() {
                                value['isActive'] = '0';
                              });
                            }
                          },
                          child: Text(value['text'],style: TextStyle(color: value['isActive']=='0'?Colors.black26:Colors.white,fontSize: Config.f15)),
                          color: value['isActive']=='0'?Colors.white:Color.fromRGBO(31, 112, 250, 1),
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
                      onPressed: (){
                        _upLoadImage();
                      },
                      child: Text('保存',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                      color: Config.themeColor,
                    ),
                  ),
                  SizedBox(height: 150.rpx,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
