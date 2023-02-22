import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fsapp/config/config.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';

class MessageDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('预警通知', leftIsExistence: true, fontColor: Colors.white,),
      body: Container(
        padding: EdgeInsets.fromLTRB(15.rpx, 0, 15.rpx, 0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50.rpx,
                    alignment: Alignment.center,
                    child: Container(
                        height: 18.rpx,
                        width: 87.rpx,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(15.rpx)
                        ),
                        child: Text('01-03 19:38',style: TextStyle(fontSize: Config.f13),)
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.rpx),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.rpx)
                    ),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Container(height: 10.rpx,width: 10.rpx,decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(10.rpx)),),
                          SizedBox(width: 5.rpx,),
                          Text('预警通知',style: TextStyle(fontWeight: FontWeight.bold,fontSize: Config.f17),),
                        ],
                      ),
                      subtitle: Text(
                        '面对悬崖峭壁，一百年也看不出一条缝来，但用斧凿，得进一寸进一寸，得进一尺进一尺，不断积累，飞跃必来，突破随之',
                          style: TextStyle(fontSize: Config.f15,color: Colors.black26),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
