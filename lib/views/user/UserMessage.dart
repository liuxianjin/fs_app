import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../components/MyAppBar.dart';
import '../../config/config.dart';
import '../../config/size_fit.dart';
import 'package:dio/dio.dart';

class UserMessage extends StatefulWidget {
  @override
  _UserMessageState createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {

  var _imgPath;
  TextEditingController _nickName;
  TextEditingController _tel;
  TextEditingController _address;

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath= image;
    });
  }

  //上传图片
  _updateUserInfo() async {
//    var isPhone = Config.isChinaPhoneLegal(_tel.text) || _tel.text == "";
//    if(isPhone==true ){
    FormData fileData = FormData.fromMap({
      'address':_address.text,
      'nickName':_nickName.text,
//      'phone':_tel.text,
      "file": _imgPath!=null ?await MultipartFile.fromFile(_imgPath.path):null,//
    });
    Http.post('/Users/updateUserInfo',data:fileData ).then((value){
      print(value);
      if(value['code']==200){
        Fluttertoast.showToast(
          msg: '修改成功',
        );
        Navigator.pushNamed(context, '/Tabs');
      }
    });
//    }else{
//      Fluttertoast.showToast(
//        msg: '请输入正确的手机号',
//      );
//    }

  }

  var _userMsg;
  _getUserInfo(){
    Http.post('/Users/getUserInfo').then((value){
      print(value);
      setState(() {
        _userMsg = value['data'];
        _nickName = TextEditingController(text: value['data']['nickName']);
        _tel = TextEditingController(text: value['data']['phone']);
        _address = TextEditingController(text: value['data']['address']);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar('用户信息',bgColor: Colors.white,fontColor: Colors.black,leftIsExistence: true,boxShadow:0),
      body:_userMsg==null?Text(''): Container(
        padding: EdgeInsets.all(20.rpx),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '头像',style: TextStyle(
                    fontSize: 18.rpx,
                    color: Colors.black45
                ),
                ),
                InkWell(
                  onTap: (){
                    _openGallery();
                  },
                  child: ClipOval(
                    child: (_imgPath != null ?ClipOval(child: Image.file(_imgPath,width: 50.rpx,height: 50.rpx,fit: BoxFit.cover,)):
                    (_userMsg['imageUrl']!=""?Image.network(_userMsg['imageUrl'],
                      width: 65.rpx,
                      height: 65.rpx,
                      fit: BoxFit.cover,
                    ):Image.asset('images/default.png',
                      width: 65.rpx,
                      height: 65.rpx,
                      fit: BoxFit.cover,
                    ))),
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '昵称',style: TextStyle(
                    fontSize: 18.rpx,
                    color: Colors.black45
                ),
                ),
                Expanded(
                  child: Container(
                    child: TextField(//昵称
                        maxLength: 10,
                        controller: _nickName,
                        textAlign:TextAlign.end,
                        decoration: InputDecoration(
                            hintText:_userMsg['nickName']==""?'请填写昵称':_userMsg['nickName'],
                            border:  OutlineInputBorder(
                                borderSide:BorderSide.none
                            )
                        )
                    ),
                  ),
                ),

              ],
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text(
//                  '电话',style: TextStyle(
//                    fontSize: 18.rpx,
//                    color: Colors.black45
//                ),
//                ),
//                Expanded(
//                  child: Container(
//                    child: TextField(//手机号
//                        controller: _tel,
//                        keyboardType: TextInputType.number,
//                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
//                        textAlign:TextAlign.end,
//                        decoration: InputDecoration(
//                            hintText:_userMsg['phone'],
//                            border:  OutlineInputBorder(
//                                borderSide:BorderSide.none
//                            )
//                        )
//                    ),
//                  ),
//                ),
//
//              ],
//            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '地址',style: TextStyle(
                    fontSize: 18.rpx,
                    color: Colors.black45
                ),
                ),
                Expanded(
                  child: Container(
                    child: TextField(//地址
//                      maxLines: 3,
                        controller: _address,
                        textAlign:TextAlign.end,
                        obscureText: false,
                        decoration: InputDecoration(
                            hintText:_userMsg['address']==""?'请填写地址':_userMsg['address'],
                            border:  OutlineInputBorder(
                                borderSide:BorderSide.none
                            )
                        )
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 200.rpx,),
            ButtonTheme(
              minWidth: 278.rpx,
              height: 47.rpx,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                ),
                onPressed: (){
                  _updateUserInfo();
                },
                child: Text('确认修改',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                color: Config.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
