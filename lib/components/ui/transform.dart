import 'package:flutter/material.dart';

Widget memoPositioning(Widget widget, double x, double y) {
  // sample
  // double yy = .8;

  // 座標値
  double yCoordinate = 0.0;
  double xCoordinate = 0.0;

  // Y座標値調整
  double setYCoordinate(double y) {
    // 微調整必要
    return y * 1;
  }

  // setting
  yCoordinate = setYCoordinate(y);
  // xCoordinate = x * yCoordinate;
  xCoordinate = x * 1;

  return Transform.scale(
    scale: yCoordinate,
    child: Transform.translate(
      offset: Offset(xCoordinate, -100),
      child: widget,
    ),
  );
}
