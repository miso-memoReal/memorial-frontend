// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoreal/components/components.dart';
import 'package:memoreal/constants/constants.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 現在地初期化
  late double lat;
  late double lon;
  late Future<List<dynamic>> memosFuture;

  // データ取得 (現在地取得とメモ位置取得)
  Future<void> getData() async {
    await getCurrentLocation();
    memosFuture = getMemoLocation();
  }

  // 現在値取得
  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
    cp = Offset(lat, lon);
  }

  // メモ位置初期化
  late List<dynamic> memos;
  // メモ位置取得
  Future<List<dynamic>> getMemoLocation() async {
    final url = Uri.parse(
        "https://api-th468.na2na.dev/api/memo/${lon.toString()}/${lat.toString()}");
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    setState(() {
      memos = json;
      mps = memos
          .map((memo) => Offset(
              double.parse(memo['latitude']), double.parse(memo['longitude'])))
          .toList();
      // ---エリア範囲算出------------------------------------
      area = getArea(cp.dx, cp.dy);

      // ---ターゲットとの差分算出-----------------------------
      locate = mps.map((mp) => Offset(mp.dx - cp.dx, cp.dy / mp.dy)).toList();
    });

    return memos;
  }

  // エリア範囲初期値
  late Map area;
  // ターゲットの表示座標
  late List<Offset> locate;
  // カレントポジション
  late Offset cp;
  // メモポジション
  late List<Offset> mps;

  // ---- センサー ---- start ------------------------------------------------

  late Offset angle = const Offset(0, 0);

  void setGyroValue(GyroscopeEvent event) {
    const extendedDistance = 1.2;
    setState(() {
      angle = angle +
          Offset((event.x * 180 / pi) * extendedDistance,
              (event.y * 180 / pi) * extendedDistance);
    });
  }

  // ---- センサー --- end ---------------------------------------------------

  // ---- 方角の取得 ---- start ----------------------------------------------
  // 北を0、東を90、西を-90、南を180若しくは-180とした方角を、sensor_plusのgyroscopeEventsとmagnetometerEventsを使って取得する
  // void calcDuration() {
  //   gyroscopeEvents
  //       .throttleTime(const Duration(milliseconds: 1000))
  //       .listen((GyroscopeEvent gyroEvent) {
  //     magnetometerEvents
  //         .throttleTime(const Duration(milliseconds: 1000))
  //         .listen((MagnetometerEvent magEvent) {});
  //   });
  // }
  // ---- 方角の取得 ---- end ------------------------------------------------

  // 初期動作
  @override
  void initState() {
    super.initState();

    // Androidデバイスの通知バー非表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    getData();

    // センサー
    gyroscopeEvents.listen(setGyroValue);

    // 指定秒ごとに実行する
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      await getData();
    });
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
      backgroundColor: Colors.transparent,
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: memosFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // エラーが発生した場合の処理
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              // データが取得されるまでの間の処理
              return const CircularProgressIndicator();
            } else {
              // データが正常に取得された場合の処理
              memos = snapshot.data!;
              area = getArea(cp.dx, cp.dy);
              locate = mps
                  .map((mp) => Offset(mp.dx - cp.dx, cp.dy / mp.dy))
                  .toList();

              return Stack(
                children: [
                  ...memos.map((memo) {
                    return Positioned(
                      top: initVertical + angle.dx,
                      left: initHorizontal + angle.dy,
                      child: memoPositioning(
                        memoCard("メモ", memo['content'], memo['distance']),
                        locate[memos.indexOf(memo)].dx,
                        locate[memos.indexOf(memo)].dy,
                      ),
                    );
                  }).toList(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
