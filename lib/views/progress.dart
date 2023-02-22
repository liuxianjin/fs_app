import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fsapp/config/config.dart';
import 'components/MyAppBar.dart';
import 'package:fsapp/config/size_fit.dart';
import 'package:barcode_scan/barcode_scan.dart';

class CircleProgressWidget extends StatefulWidget {
  Map arguments;
  CircleProgressWidget({Key key, this.arguments }) : super(key: key);
  @override
  _CircleProgressWidgetState createState() => _CircleProgressWidgetState(arguments:this.arguments);
}

class _CircleProgressWidgetState extends State<CircleProgressWidget> {
  Map arguments;
  _CircleProgressWidgetState({this.arguments});


  int _progress = 0;
  _getQuantity(){
      setState(() {
        _progress = int.parse(arguments['bat']);
      });
  }

  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getQuantity();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('设备电量', fontColor: Colors.white,leftIsExistence: true,boxShadow: 0,),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Config.themeColor,
              ),
            ),
            CustomPaint(
              foregroundPainter: new MyPainter(
                _progress,
                lineColor: Colors.lightBlueAccent,
                width: 8.0,

              ),
            ),
            Positioned(
              top: 190.rpx,
              left: SizeFit.getWidth()/2-130.rpx,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: 260.rpx,
                    child: Text('$_progress%',style: TextStyle(fontSize: 50.rpx,color: Colors.white,),),
                  ),
                  SizedBox(height: 10.rpx,),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'images/loging.png',
                        width: 12.rpx,
                        height: 12.rpx,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        '正在使用',
                        style: TextStyle(
                            fontSize: Config.f21,
                            color: Colors.white
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.rpx,),
                  Container(
                    width: 43.rpx,
                    height: 20.rpx,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 40.rpx,
                          height: 20.rpx,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.rpx),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5.rpx
                            )
                          ),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(1.5.rpx, 1.5.rpx, (1.5+(40/100)*(100-_progress)).rpx, 1.5.rpx),
                            decoration: BoxDecoration(
                                color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5.rpx,
                          right: 0.rpx,
                          child: Container(
                            width: 4.rpx,
                            height: 8.rpx,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.rpx),
                                color: Colors.white,
                            ),

                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
          ],
        )
      )
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  double width;
  int progress;

  MyPainter(this.progress,{this.lineColor, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    const PI = 3.1415926;
    int progress = this.progress;
    Paint _paint = new Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(SizeFit.getWidth()/2, 250.0), 130.rpx, _paint);

    Paint _myPaint = new Paint()
      ..color = Color.fromRGBO(72, 255, 0, 1)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: Offset(SizeFit.getWidth()/2, 250.0), radius: 130.rpx),
        29.9, PI*2/100*progress, false,
        _myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
