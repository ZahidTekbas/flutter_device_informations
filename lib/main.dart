import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'dart:async';
import 'dart:io';
import 'readData.dart';
import 'batteryIndicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Device Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Device Information'),
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
  double fontSizeOfSubtitle = 14.0;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Device Informations')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Indicator(),
            Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(
                  color: Colors.blue.shade100,
                  width: 1.0,
                ),
              ),
              height: MediaQuery.of(context).size.height / 1.2,
              child: ListView(
                children: _deviceData.keys.map((String property) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        padding: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 150.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          elevation: 8.0,
                          child: SingleChildScrollView(
                            primary: true,
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: Text(
                                '$property',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w300),
                              ),
                              children: <Widget>[
                                Scrollbar(
                                  child: Text('${_deviceData[property]}',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black87)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
