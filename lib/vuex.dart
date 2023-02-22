
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyVuex extends InheritedWidget{
  //1.共享的数据

  final int counter;
  //2.自定义构造方法
  MyVuex({this.counter, Widget child}) : super(child: child);

  static MyVuex of(BuildContext context){
    //3.沿着ele 树 去找到最近的MyVuex  从中取出 Widget对象 
    return context.dependOnInheritedWidgetOfExactType();
  }

  //4.决定要不要回调state中的didChangeDependencies
  @override
  bool updateShouldNotify(MyVuex oldWidget) {
    //更新的时候要不要通知   false：
    //true  执行 didChangeDependencies 方法
    return oldWidget.counter != counter;
  }
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '状态管理',
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  int _counter = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('状态管理'),),
      body: MyVuex(
        counter: _counter,
        child:Column(
          children: <Widget>[
            showData(),
            showData1()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          setState(() {
            _counter++;
          });
        },
      ),
    );
  }
}


class showData extends StatefulWidget {
  showData({Key key}) : super(key: key);
  _showDataState createState() => _showDataState();
}

class _showDataState extends State<showData> {

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      print('执行了showData中的---didChangeDependencies');
    }
    
  @override
  Widget build(BuildContext context) {
  
    int counter = MyVuex.of(context).counter;

    return Card(
      color: Colors.red,
      child: Text('当前计数器：$counter'),
    );
  }
}


class showData1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    int counter = MyVuex.of(context).counter;

    return Card(
      color: Colors.blue,
      child: Text('当前计数器：$counter'),
    );
  }
}

