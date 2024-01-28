import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfirmSendArguments {
  final String str;
  final String lat;
  final String lon;

  ConfirmSendArguments(
      {required this.str, required this.lat, required this.lon});
}

class MemoConfirm extends StatelessWidget {
  const MemoConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ConfirmSendArguments;

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.blue.withOpacity(0.1),
        ),
        Container(
          color: Colors.blue.withOpacity(0.1),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/memoCreate");
            },
            backgroundColor: Colors.transparent,
            elevation: 0, // 影を表示しない
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(50), // 円形の形状にする
            ),
            // shape: CircleBorder(side: Colors.black87),
            child: Image.asset(
              'lib/assets/images/backicon.png', // イメージのパス
              // width: 24, // 画像のサイズを指定
              // height: 24,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                const Text(
                  "メモ内容",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                Container(
                  // color: Colors.blue,
                  width: 350,
                  padding: const EdgeInsets.all(100),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5FC569), // 背景色を指定
                    borderRadius: BorderRadius.circular(10.0), // 任意の角丸を指定
                  ),
                  child: Text(
                    args.str,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FC569),
                    // minimumSize: const Size(198, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    final url =
                        Uri.parse('https://api-th468.na2na.dev/api/memo');
                    http.post(url, body: {
                      'content': args.str,
                      'latitude': args.lat,
                      'longitude': args.lon,
                    });
                    Navigator.pushNamed(context, "/");
                  },
                  child: const Text("作成", style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
