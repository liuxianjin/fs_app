import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fsapp/config/dio.dart';
import '../components/MyAppBar.dart';
import '../../config/size_fit.dart';

class UserAgreement extends StatefulWidget {
  @override
  _UserAgreementState createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {

  String _text = '';
  String _html;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Http.post('/Info/getUserAgreementInfo').then((res){
       print(res['data']['content']);
       setState(() {
         _html = res['data']['content'];
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar('用户协议', bgColor: Colors.white, boxShadow: 0,fontColor: Colors.black,leftIsExistence: true,),
        body:Padding(
          padding: EdgeInsets.fromLTRB(15.rpx, 8.rpx, 15.rpx, 8.rpx),
          child: ListView(
            children: <Widget>[
              Html(
                data:_html??""
              ),
            ],
          ),
        )
    );
  }
}

