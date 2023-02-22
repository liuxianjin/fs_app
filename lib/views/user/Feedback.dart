import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import '../components/MyAppBar.dart';
import '../../config/config.dart';
import '../../config/size_fit.dart';
import 'package:image_picker/image_picker.dart';


class Back extends StatefulWidget {
  @override
  _BackState createState() => _BackState();
}

class _BackState extends State<Back> {
  final _content = TextEditingController();
  final _tel = TextEditingController();
  bool _disable = false;
  List<File> imgListArr = new List();

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    _upLoadImage(image);
    if(image != null){
      setState(() {
        imgListArr.add(image);
      });
    }
  }
  //上传图片

  //上传图片
  _upLoadImage() async {
    if(_content.text!=''){
      if(_disable){
        return null;
      }else{
        setState(() {
          _disable = true;
        });
        FormData fileData = FormData.fromMap({
          'content':_content.text,
          "file1":imgListArr.length>0?MultipartFile.fromFileSync(imgListArr[0].path):null,
          "file2":imgListArr.length>1?MultipartFile.fromFileSync(imgListArr[0].path):null,
          "file3":imgListArr.length>2?MultipartFile.fromFileSync(imgListArr[0].path):null,
        });
        Http.post('/Info/saveOpinion',data:fileData,options: Options(headers: {
          'Content-type':"multipart/form-data"
        })).then((value){
          if(value['code'] == 200){
            Fluttertoast.showToast(
              msg: '反馈成功',
            );
            setState(() {
              _disable = false;
            });
            Navigator.pushNamed(context, '/Tabs');
          }else{
            Fluttertoast.showToast(
              msg: value['desc'],
            );
            setState(() {
              _disable = false;
            });
          }
        });
      }

    }else{
      Fluttertoast.showToast(
        msg: '请输入反馈意见',
      );
    }

  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgListArr.add(image);
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar('意见反馈',bgColor: Colors.white,fontColor: Colors.black,leftIsExistence: true,boxShadow:0),
        body:GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.all(15.rpx),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(244, 244, 245, 1)
                      )
                    )
                  ),
                  child: TextField(//手机号
                      controller: _content,
                      maxLines: 6,
                      enableInteractiveSelection:false,
                      decoration: InputDecoration(
                          hintText:'请输入反馈意见与建议',
                          border:  OutlineInputBorder(
                              borderSide:BorderSide.none
                          )
                      )
                  ),
                ),
//              Container(
//                decoration: BoxDecoration(
//                    border: Border(
//                        bottom: BorderSide(
//                          color: Color.fromRGBO(244, 244, 245, 1)
//                        )
//                    )
//                ),
//                child: TextField(//手机号
//                    autofocus:false,
//                    controller: _tel,
//                    decoration: InputDecoration(
//                        hintText:'请输入手机号',
//                        border:  OutlineInputBorder(
//                            borderSide:BorderSide.none
//                        )
//                    )
//                ),
//              ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10.rpx, 0, 10.rpx),
                    child: Text('上传图片（最多3张）',style: TextStyle(fontSize: Config.f17,color:Colors.black45 ),)
                ),
                Row(
                  children: <Widget>[
//                  Image.asset('',width:79.rpx,),
//                  Image.asset('',width:79.rpx,),
//        Text(''),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      spacing: 10,
                      children:  List.generate(imgListArr.length, (i) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(3.rpx),
                          child: Container(
                            width: 79.rpx,
                            height: 79.rpx,
                            child: Stack(
                              children: <Widget>[

                                Image.file(imgListArr[i],width:79.rpx,height: 79.rpx,fit: BoxFit.cover,),
                                Align(
                                  alignment: Alignment(1,-1),
                                  child: Container(
                                      width: 15.rpx,
                                      height: 15.rpx,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(221, 221, 221, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.rpx)
                                          )
                                      ),
                                      child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              imgListArr.removeAt(i);
                                            });
                                          },
                                          child: Icon(Icons.close,color: Colors.red,size: 13.0,)
                                      )
                                  ),
                                ),
//                      Icon(Icons.close,color: Colors.red,size: 40.0,),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(width: 15.rpx,),
                    InkWell(
                        onTap: _openGallery,
                        child:imgListArr.length>=3 ?Text(''): Image.asset('images/up_img.png',width:79.rpx,)
                    ),
                  ],
                ),

                SizedBox(height: 150.rpx,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 278.rpx,
                      height: 47.rpx,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                        ),
                        onPressed: (){
                          _upLoadImage();
//                        Navigator.pushNamed(context, '/Tabs');
                        },
                        child: Text('我要反馈',style: TextStyle(color: Colors.white,fontSize: Config.f15)),
                        color: Config.themeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
