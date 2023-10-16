import 'package:flutter/material.dart';
import 'package:memoreal/constants/constants.dart';
import 'package:memoreal/page/pages.dart';

void main() {
  // 初期化
  WidgetsFlutterBinding.ensureInitialized();
  // 起動
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // デバッグラベル非表示
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
        //   // 非表示
        //   elevation: 0.0,
        //   color: Colors.transparent
          color: ColorConstants.themeColor
        )
      ),
      home: const HomePage(),
    );
  }
}
