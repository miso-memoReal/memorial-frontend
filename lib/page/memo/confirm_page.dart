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
                const Text(
                  "メモ内容",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  args.str,
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FC569),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    final url = Uri.parse(
                        'https://nginx-na2na-p.cloud.okteto.net/api/memo');
                    http.post(url, body: {
                      'content': args.str,
                      'latitude': args.lat,
                      'longitude': args.lon,
                    });
                    Navigator.pushNamed(context, "/");
                  },
                  child: const Text("メモを作成", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
