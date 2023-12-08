// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memoreal/constants/constants.dart';
import 'package:memoreal/routes/route.dart';

import 'page/pages.dart';

// import 'package:memoreal/page/pages.dart';

// カメラデバイス情報のリスト定義
List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    // 初期化
    WidgetsFlutterBinding.ensureInitialized();

    // 環境変数読み込み
    await dotenv.load(fileName: ".env");

    // デバイスで使用可能なカメラのリストを取得
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(ErrorConstants.getCameraTitle + "$e");
  }

  // 起動
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // カメラの初期設定をこっちに移す。。。。???

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // デバッグラベル非表示
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      routes: routes,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              //   // 非表示
              //   elevation: 0.0,
              //   color: Colors.transparent
              color: ColorConstants.themeColor)),
      // home: const HomePage(),
      home: const HomePage(),
    );
  }
}
