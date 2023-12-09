// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoreal/components/components.dart';
import 'package:memoreal/constants/constants.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 現在値取得
  Map cJson = jsonDecode(currentInfoString);
  // メモ位置取得
  Map memo = jsonDecode(memoInfoString);
  // エリア範囲初期値
  late Map area;
  // ターゲットの表示座標
  late Offset locate;
  // カレントポジション
  late Offset cp = Offset(cJson["x"], cJson["y"]);
  // メモポジション
  late Offset mp = Offset(memo["x"], memo["y"]);

  // ---- センサー ---- start ------------------------------------------------

  late Offset angle = const Offset(0, 0);

  void setGyroValue(GyroscopeEvent event) {
    const extendedDistance = 1.2;
    setState(() {
      angle = angle +
          Offset((event.x * 180 / pi) * extendedDistance,
              (event.y * 180 / pi) * extendedDistance);
    });
    print(angle);
  }

  // void setAcceleromtorValue(AccelerometerEvent event) {
  //   setState(() {
  //     angle = angle + Offset(event.z, event.x);
  //   });
  //   print(angle);
  // }

  // ---- センサー --- end ---------------------------------------------------

  // 初期動作
  @override
  void initState() {
    // Androidデバイスの通知バー非表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    setState(() {
      // ---エリア範囲算出------------------------------------
      area = getArea(cp.dx, cp.dy);

      // ---ターゲットとの差分算出-----------------------------
      locate = Offset(
          // X座標
          mp.dx - cp.dx,
          // Y座標
          cp.dy / mp.dy);
    });

    // センサー
    gyroscopeEvents.listen(setGyroValue);
    // accelerometerEvents.listen(setAcceleromtorValue);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // デフォルトのポジション調整の値
    double initHorizontal = size.width / 7;
    double initVertical = size.height / 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.homeTitle,
          style: TextStyle(color: Color.fromARGB(255, 64, 73, 92)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: initVertical + angle.dx,
              left: initHorizontal + angle.dy,
              child: memoPositioning(memoCard(memo['title'], memo['content']),
                  locate.dx, locate.dy),
            ),
            Positioned(
                top: size.height - 200,
                left: size.width / 3,
                child: SizedBox(
                  width: size.width / 3,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        angle = const Offset(0.0, 0.0);
                      });
                    },
                    child: const Center(child: Text('リセット')),
                  ),
                ))
          ],
          // children: [
          //   Text("ジャイロセンサーの値:\n$gyroscopeValue"),
          //   Text("\nメモとのX座標差分: " + locate["x"].toString()),
          //   Text("\nメモとのy座標スケール値: " + locate['y'].toString()),
          //   Text("\n現在値 x: " +
          //       cInfo['x'].toString() +
          //       ", y: " +
          //       cInfo['y'].toString()),
          //   Text("\nメモ位置 x: " +
          //       memo['x'].toString() +
          //       ", y: " +
          //       memo['y'].toString()),
          //   Text("\nエリア \n top:  " +
          //       area['top'].toString() +
          //       ", \n right:  " +
          //       area['right'].toString() +
          //       ", \n bottom:  " +
          //       area['bottom'].toString() +
          //       ", \n left:  " +
          //       area['left'].toString()),
          // ],
        ),
      ),
    );
  }
}
