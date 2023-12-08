// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoreal/components/components.dart';
import 'package:memoreal/components/location.dart';
import 'package:memoreal/components/ui/transform.dart';
import 'package:memoreal/constants/constants.dart';
import 'package:memoreal/page/mock.dart';
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
  late Offset currentPosi = Offset(cJson["x"], cJson["y"]);
  late Offset memoPosi = Offset(memo["x"], memo["y"]);

  // ジャイロセンサー ---- start ------------------------------------------------
  static const _interval = 0.02;
  static const _maxAngle = 180;
  static const _maxForegroundMove = Offset(0, 0);
  static const _inititalForegroundOffset = Offset(0, 0);

  late StreamSubscription<GyroscopeEvent> streamGyrpscopeEvent;

  Offset foregroundOffset = _inititalForegroundOffset;

  void listenGyroscopeEvent(GyroscopeEvent event) {
    final angle =
        Offset(event.x * _interval * 180 / pi, event.y * _interval * 180 / pi);

    final addForegroundOffset = Offset(
        angle.dx / _maxAngle * _maxForegroundMove.dx,
        angle.dy / _maxAngle * _maxForegroundMove.dy);

    if (angle.dx >= _maxAngle || angle.dy >= _maxAngle) {
      return;
    }

    final newForegroundOffse = foregroundOffset + addForegroundOffset;

    if (newForegroundOffse.dx >=
            _inititalForegroundOffset.dx + _maxForegroundMove.dx ||
        newForegroundOffse.dx <=
            _inititalForegroundOffset.dx - _maxForegroundMove.dx ||
        newForegroundOffse.dy >=
            _inititalForegroundOffset.dy + _maxForegroundMove.dy ||
        newForegroundOffse.dy <=
            _inititalForegroundOffset.dy - _maxForegroundMove.dy) {
      return;
    }

    setState(() {
      foregroundOffset = foregroundOffset + addForegroundOffset;
    });
  }

  // ジャイロセンサー --- end ---------------------------------------------------

  // 初期動作
  @override
  void initState() {
    // Androidデバイスの通知バー非表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    setState(() {
      // ---エリア範囲算出------------------------------------
      area = getArea(currentPosi.dx, currentPosi.dy);

      // ---ターゲットとの差分算出-----------------------------
      locate =
          getLocate(currentPosi.dx, memoPosi.dx, currentPosi.dx, memoPosi.dy);
    });

    // ジャイロセンサー
    streamGyrpscopeEvent = gyroscopeEvents.listen((listenGyroscopeEvent));

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
        child: Stack(
          children: [
            Positioned(
              top: foregroundOffset.dx - _inititalForegroundOffset.dx,
              left: foregroundOffset.dy - _inititalForegroundOffset.dy,
              child: memoPositioning(
                  memoCard(memo['title'], memo['body']), locate.dx, locate.dy),
            )
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
