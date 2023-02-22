  import 'package:flutter/material.dart';

  void main() => runApp(MyApp());

  class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: '字体大小'),
      );
    }
  }

  class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {

    double rangeSlideMin = 0;
    double rangeSlideMax = 7;
    String titleTxt = '小号';

    void _rangeSlideChange(min, max) {
      setState(() {
        rangeSlideMin = min;
        rangeSlideMax = max;
      });

      // if(max<40){
      //   setState(() {
      //     titleTxt = '中号';
      //   });
      // }
    }

    Widget getRangeSlider() {
      return SliderTheme(
        //样式的设计
        data: SliderThemeData(
          inactiveTickMarkColor: Colors.red,
          inactiveTrackColor: Colors.yellow,
        ),
        child: RangeSlider(
          //滑动时上方的提示标签
          labels: RangeLabels("小号", "$rangeSlideMax"),
          //当前Widget滑块的值
          values: RangeValues(15, rangeSlideMax),
          //最小值
          min: 20,
          //最大值
          max: 100,
          //最小滑动单位值
          divisions: 7,
          //未滑动的颜色
          inactiveColor: Colors.grey,
          //活动的颜色
          activeColor: Colors.blue,
          //滑动事件
          onChanged: (RangeValues values) {
            //滑动时更新widget的状态值
            _rangeSlideChange(values.start, values.end);
          },
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'AgedCare',
              ),
              Text(
                '预览字体大小',
                style: TextStyle(
                  fontSize: 15.0
                ),
              ),
              SizedBox(height: 100),
              getRangeSlider(),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }