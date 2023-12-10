import 'package:flutter/material.dart';
import 'confirm_page.dart';
import 'package:geolocator/geolocator.dart';

class MemoCreate extends StatefulWidget {
  const MemoCreate({super.key});

  @override
  MemoCreateState createState() => MemoCreateState();
}

class MemoCreateState extends State<MemoCreate> {
  String argtext = ''; // メモの内容を保持する変数

  // 現在地取得
  late String lat;
  late String lon;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude.toString();
      lon = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('memocreate'),
      ),
      body: Column(
        children: [
          const Text("メモ内容"),
          TextField(
            onChanged: (value) {
              setState(() {
                argtext = value; // テキストの変更をargtextに保存
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              // 一時的な変数に保存
              BuildContext currentContext = context;

              getCurrentLocation().then((_) {
                // 保存したBuildContextを使用
                Navigator.pushNamed(currentContext, "/memoConfirm",
                    arguments:
                        ConfirmSendArguments(str: argtext, lat: lat, lon: lon));
              });
            },
            child: const Text('確認へ進む'),
          ),
        ],
      ),
    );
  }
}
