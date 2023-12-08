import 'package:flutter/material.dart';

Widget memoPositioning(Widget widget, double x, double y) {
  // sample
  // double yy = .8;

  // 座標値
  double yCoordinate = 0.0;
  double xCoordinate = 0.0;

  // Y座標値調整
  double setYCoordinate(double y) {
    double yCoordinate = 0.0;
    // 微調整必要
    yCoordinate = y;
    return yCoordinate;
  }

  // setting
  yCoordinate = setYCoordinate(y);
  xCoordinate = x * yCoordinate;

  return Transform.scale(
    scale: y,
    child: Transform.translate(
      offset: Offset(xCoordinate, 200),
      child: widget,
    ),
  );
}
