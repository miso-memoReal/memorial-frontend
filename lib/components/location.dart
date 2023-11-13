// エリア取得
Map<String, double> getArea(double x, double y) {
  // エリア半径 (修正可)
  const double areaRadius = 100.0;

  final top = y + areaRadius;
  final right = x + areaRadius;
  final bottom = y - areaRadius;
  final left = x - areaRadius;

  return {"top": top, "right": right, "bottom": bottom, "left": left};
}

// cX, cY => 現在地座標
// mX, mY => メモ座標

// 座標差分
// x: x座標差分
// y: スケール値
Map<String, double> getLocate(double cX, double mX, double cY, double mY) {
  return {"x": getLocateX(cX, mX), "y": getLocateY(cY, mY)};
}

getLocateX(double cX, double mX) {
  double lctX = 0.0;
  lctX = mX - cX;
  return lctX;
}

getLocateY(double cY, double mY) {
  double lctYper = 0.0;
  int per = 100;
  double diff = mY - cY;
  lctYper = 1 - (diff / per);
  return lctYper;
}
