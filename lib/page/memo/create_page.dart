import 'dart:ui';

import 'package:flutter/material.dart';

import 'confirm_page.dart';
import 'package:geolocator/geolocator.dart';

class MemoCreate extends StatefulWidget {
  const MemoCreate({Key? key}) : super(key: key);

  @override
  MemoCreateState createState() => MemoCreateState();
}

class MemoCreateState extends State<MemoCreate> {
  String argtext = '';

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white.withOpacity(0.1),
          ),
          // 透明な背景とブラー効果
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.transparent, // 透明な背景色
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent, // Scaffoldの背景を透明に
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, "/cameraPage");
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset(
                'lib/assets/images/backicon.png',
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 150),
                const Text(
                  "メモ内容",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 350,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF5FC569)),
                          ),
                          filled: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            argtext = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FC569),
                    minimumSize: const Size(198, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    // 一時的な変数に保存
                    BuildContext currentContext = context;

                    getCurrentLocation().then((_) {
                      // 保存したBuildContextを使用
                      Navigator.pushNamed(currentContext, "/memoConfirm",
                          arguments: ConfirmSendArguments(
                              str: argtext, lat: lat, lon: lon));
                    });
                  },
                  child: const Text(
                    '確認へ進む →',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
