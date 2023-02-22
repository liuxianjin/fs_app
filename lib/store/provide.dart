//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'index.dart';
//
///**
// * 1.创建自己需要共享的数据
// * 2.在应用程序的顶层创建ChangeNotifierProvider
// * 3.在其他位置使用共享的数据
// * Consumer:推荐 只会重新执行 Consumer里面的函数
// * Provider.of 改变整个build
// * Selector
// */
//
//
////void main(){
////  runApp(
////      MultiProvider(
////        providers: [
////          ChangeNotifierProvider(create: (cxt) => CounterStore(),),
////          ChangeNotifierProvider(create: (cxt) => UserViewModel(),)
////        ],
////      )
////  );
////}
//
//void main(){
//  runApp(
//    ChangeNotifierProvider(
//      create: (ctx) => CounterStore(),
//      child: MyApp(),
//    )
//  );
//}
//
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  SharedPreferences prefs;
//
//  _local () async{
//    prefs = await SharedPreferences.getInstance();
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _local();
//    prefs.setInt('age',18);
//  }
//
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: '状态管理',
//      home: MyHome(),
//    );
//  }
//}
//
//class MyHome extends StatefulWidget {
//  MyHome({Key key}) : super(key: key);
//
//  @override
//  _MyHomeState createState() => _MyHomeState();
//}
//
//class _MyHomeState extends State<MyHome> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text('状态管理'),),
//      body:Column(
//          children: <Widget>[
//            showData(),
//            showData1()
//          ],
//        ),
//      floatingActionButton: Consumer<CounterStore>(
//        builder: (ctx, counterVM, child){
//          return FloatingActionButton(
//            child: Icon(Icons.add),
//            onPressed: (){
//              counterVM.counter += 1;
//            },
//          );
//        },
//      )
//    );
//  }
//}
//
//
//class showData extends StatefulWidget {
//  showData({Key key}) : super(key: key);
//  _showDataState createState() => _showDataState();
//}
//
//class _showDataState extends State<showData> {
//
//    @override
//    void didChangeDependencies() {
//      super.didChangeDependencies();
//      print('执行了showData中的---didChangeDependencies');
//    }
//
//  @override
//  Widget build(BuildContext context) {
//      int counter = Provider.of<CounterStore>(context).counter;
//    return Card(
//      color: Colors.red,
//      child: Text('当前计数器：$counter'),
//    );
//  }
//}
//
//
//class showData1 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//      color: Colors.blue,
//      child: Consumer<CounterStore>(
//        builder: (context,  VM, child){
//          return Text('当前计数器：${VM.counter}');
//        },
//      )
//    );
//  }
//}
//
