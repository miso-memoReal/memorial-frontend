import 'package:flutter/material.dart';
import 'package:memoreal/page/memo/confirm_page.dart';
import 'package:memoreal/page/memo/create_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/memocreate': (context) => MemoCreate(),
  '/memoconfirm': (context) => MemoConfirm(),
  // 他の画面のルートをここに追加
};