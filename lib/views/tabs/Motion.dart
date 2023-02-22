import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsapp/config/dio.dart';
import '../../config/config.dart';
import 'package:fsapp/config/size_fit.dart';

class Motion extends StatefulWidget {
  Motion({Key key}) : super(key: key);

  @override
  _MotionState createState() => _MotionState();
}

class _MotionState extends State<Motion> {
  String _relationship ='0';
  List motionList = [];

//  _getList(){
//    Http.post('/Info/getSportList').then(
//      (value) {
//        print(value['data']);
//        setState(() {
//          motionList = value['data'];
//        });
//        print(motionList.map((item){
//          return DropdownMenuItem(value: item['code'],child: Text(item['sportName'],style: TextStyle(fontSize: Config.f15)));
//        }).toList());
//      }
//    );
//  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _getList();
  }

  @override
  Widget build(BuildContext context) {
    SizeFit.initialize();
    return Container(
        padding: EdgeInsets.all(15.rpx),
       child: ListView(
         children: <Widget>[
           InkWell(
             onTap: (){
               print('111');
//               Navigator.pushNamed(context, '/Activity');
             },
             child: InkWell(
               onTap: (){
                 Navigator.pushNamed(context, '/NetworkFence');
               },
               child: Container(
                 width: 346.rpx,
                 height: 87.rpx,
                 padding: EdgeInsets.all(15.rpx),
                 margin: EdgeInsets.fromLTRB(0, 0, 0, 10.rpx),
                 decoration: BoxDecoration(
                   color: Color.fromRGBO(100,175,231,.2),
                   borderRadius: BorderRadius.all(
                       Radius.circular(10.rpx)
                   )
                 ),
                   child:Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       Row(
                         children: <Widget>[
                           Image.asset('images/lot.png',width: 40.rpx,),
                           SizedBox(width: 20.rpx),
                           Text(
                             '电子围栏',
                             style: TextStyle(
                               fontSize: Config.f17,
                             ),
                           ),
                         ],
                       ),
                       Icon(
                           Icons.arrow_forward_ios,
                           color: Color.fromRGBO(128, 133, 141, 1),
                           size:20.rpx
                       )
                     ],
                   )
                ),
             ),
           ),
           InkWell(
             onTap: (){
               Navigator.pushNamed(context, '/Activity');
             },
             child: Container(
                 width: 346.rpx,
                 height: 87.rpx,
                 padding: EdgeInsets.all(15.rpx),
                 decoration: BoxDecoration(
                     color: Color.fromRGBO(100,175,231,.2),
                     borderRadius: BorderRadius.all(
                         Radius.circular(10.rpx)
                     )
                 ),
                 child:Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Row(
                       children: <Widget>[
                         Image.asset('images/guiji.png',width: 40.rpx,),
                         SizedBox(width: 20.rpx),
                         Text(
                           '活动轨迹',
                           style: TextStyle(
                             fontSize: Config.f17,
                           ),
                         ),
                       ],
                     ),
                     Icon(
                       Icons.arrow_forward_ios,
                       color: Color.fromRGBO(128, 133, 141, 1),
                       size:20.rpx
                     )
                   ],
                 )
             ),
           ),
           SizedBox(height: 10.rpx,),
//           InkWell(
//             onTap: (){
////               Navigator.pushNamed(context, '/Activity');
//             },
//             child: Container(
//                 width: 346.rpx,
//                 height: 87.rpx,
//                 padding: EdgeInsets.all(15.rpx),
//                 decoration: BoxDecoration(
//                     color: Color.fromRGBO(100,175,231,.2),
//                     borderRadius: BorderRadius.all(
//                         Radius.circular(10.rpx)
//                     )
//                 ),
//                 child:Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         Image.asset('images/pao.png',width: 40.rpx,),
//                         SizedBox(width: 20.rpx),
//                         Text(
//                           '运动模式',
//                           style: TextStyle(
//                             fontSize: Config.f17,
//                           ),
//                         ),
//                       ],
//                     ),
//                     DropdownButton(
//                       value: _relationship,
//                       items:
//                       motionList.map((item){
//                         return DropdownMenuItem(value: item['code'],child: Text(item['sportName'],style: TextStyle(fontSize: Config.f15)));
//                       }).toList(),
////                       [
////                         DropdownMenuItem(value: '0',child: Text('跑步',style: TextStyle(fontSize: Config.f15))),
////                         DropdownMenuItem(value: '1',child: Text('步行',style: TextStyle(fontSize: Config.f15))),
////                       ],
//                       onChanged: (value) {
//                         print(value);
//                         var temp;
//                         motionList.forEach((item){
//                           if(item['code'] == value){
//                             temp = item;
//                           }
//                         });
//                         print('临时数据${temp}');
//                         Http.post('/Device/deviceRwa',params: {
//                           'sportId':temp['id']
//                         }).then((value){
//                           if(value['code']==200){
//                             Fluttertoast.showToast(msg: '切换成功');
//                             setState(() {
//                               _relationship = value;
//                             });
//                           }else{
//                             Fluttertoast.showToast(msg: value['desc']);
//                           }
//                         });
//                       },
//                       underline:Container(height: 0,),
//                     )
//                   ],
//                 )
//             ),
//           )
         ],
       ),
    );
  }
}