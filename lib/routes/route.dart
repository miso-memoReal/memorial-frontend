import 'package:flutter/material.dart';
import 'package:memoreal/page/camera_page.dart';
import 'package:memoreal/page/memo/confirm_page.dart';
import 'package:memoreal/page/memo/create_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/cameraPage': (context) => const CameraPage(),
  '/memoCreate': (context) => const MemoCreate(),
  '/memoConfirm': (context) => const MemoConfirm(),
  // 他の画面のルートをここに追加
};
