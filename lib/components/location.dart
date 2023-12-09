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


Map getMemo(Map memo) {
  return {
    "title": memo['title'],
    "body": memo['body'],
    "createAt": memo['createAt'],
    "updateAt": memo['updateAt'],
  };
}
