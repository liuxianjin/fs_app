import 'package:flutter/material.dart';
import 'package:amap_core_fluttify/amap_core_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:permission_handler/permission_handler.dart';

class Position extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('定位'),),
      body: MyHomePage(title: '高德地图测试'),
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
  Location _location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                requestPermission();
              },
              child: Text('定位'),
            ),
            RaisedButton(
              child: Text('获取连续定位'),
              onPressed: () async {
                // if (await requestPermission()) {
                await for (final location
                in AmapLocation.instance.listenLocation()) {
                  setState(() => _location = location);
                }
                // }
              },
            ),
            RaisedButton(
              child: Text('停止定位'),
              onPressed: () async {
                // if (await requestPermission()) {
                await AmapLocation.instance.stopLocation();
                setState(() => _location = null);
                // }
              },
            ),
            if (_location != null)
              Center(
                child: Text(
                  _location.latLng.latitude.toString() +
                      _location.latLng.longitude.toString() +
                      _location.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void requestPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final location = await AmapLocation.instance.fetchLocation();
      setState(() => _location = location);
    } else {
      if (await Permission.location.request().isGranted) {
        final location = await AmapLocation.instance.fetchLocation();
        setState(() => _location = location);
      }
    }
  }
}
