import 'package:flutter/material.dart';
import 'package:memoreal/constants/constants.dart';

Widget memoCard(String title, String body, String distance) {
  final bodyLen = body.length;
  double cardHeight = 0;
  double rate = double.parse(distance) / 100;

  double getHeight(int strLen) {
    const maxLen = 32;
    double height = 25;
    int add = 0;

    add = 1 + (strLen ~/ maxLen);

    height = height * add.toDouble();
    return height + title.length.toDouble();
  }

  cardHeight = 100 + getHeight(bodyLen) + title.length.toDouble();

  return (SizedBox(
      width: 300,
      height: cardHeight - (rate * cardHeight),
      child: Card(
        color: ColorConstants.accentColor,
        elevation: 5,
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900)),
              ),
              Container(
                  width: 260,
                  height: 0,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1)))),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(body, style: const TextStyle(fontSize: 16)),
              ),
            ])),
      )));
}
