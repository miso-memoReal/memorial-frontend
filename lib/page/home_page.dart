// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoreal/components/location.dart';
import 'package:memoreal/constants/constants.dart';
import 'package:memoreal/page/mock.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 表示用ジャイロセンサー初期値
  String gyroscopeValue = "";
  // 現在値取得
  Map currentLocation = jsonDecode(currentLocationString);
  // メモ位置取得
  Map memoLocation = jsonDecode(memoLocationString);
  // エリア範囲初期値
  late Map area;
  // ターゲットの表示座標
  late Map locate = {"x": 0.0, "y": 0.0};

  // ジャイロセンサー
  final gyroscopeAvailable = gyroscopeEvents != null;

  // 初期動作
  @override
  void initState() {
    // Androidデバイスの通知バー非表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // ---ジャイロセンサーの値表示--------------------------
    //
    gyroscopeEvents.listen((GyroscopeEvent e) {
      setState(() {
        gyroscopeValue = "x: ${e.x}, \n y: ${e.y}, \n z: ${e.z}";
      });
    }, onError: (error) {
      print(error);
    }, cancelOnError: true);

    // ---エリア範囲算出------------------------------------
    //
    setState(() {
      area = getArea(currentLocation["x"], currentLocation["y"]);
    });

    // ---ターゲットとの差分算出-----------------------------
    //
    setState(() {
      locate = getLocate(currentLocation["x"], memoLocation["x"],
          currentLocation["y"], memoLocation["y"]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.homeTitle,
          style: TextStyle(color: Color.fromARGB(255, 64, 73, 92)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text("ジャイロセンサーの値:\n$gyroscopeValue"),
            Text("\nメモとのX座標差分: " + locate["x"].toString()),
            Text("\nメモとのy座標スケール値: " + locate['y'].toString()),
            Text("\n現在値 x: " +
                currentLocation['x'].toString() +
                ", y: " +
                currentLocation['y'].toString()),
            Text("\nメモ位置 x: " +
                memoLocation['x'].toString() +
                ", y: " +
                memoLocation['y'].toString()),
            Text("\nエリア \n top:  " +
                area['top'].toString() +
                ", \n right:  " +
                area['right'].toString() +
                ", \n bottom:  " +
                area['bottom'].toString() +
                ", \n left:  " +
                area['left'].toString()),
          ],
        ),
      ),
    );
  }
}
