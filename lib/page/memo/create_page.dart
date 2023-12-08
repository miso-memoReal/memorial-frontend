import 'dart:ui';

import 'package:flutter/material.dart';

import 'confirm_page.dart';

class MemoCreate extends StatefulWidget {
  const MemoCreate({Key? key}) : super(key: key);

  @override
  MemoCreateState createState() => MemoCreateState();
}

class MemoCreateState extends State<MemoCreate> {
  String argtext = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 透明度が99%の白い背景
          Container(
            color: Colors.blue.withOpacity(0.1),
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
                const SizedBox(height: 100),
                const Text(
                  "メモ内容",
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF5FC569)),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FC569),
                    minimumSize: const Size(198, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/memoConfirm",
                      arguments: ConfirmSendArguments(str: argtext),
                    );
                  },
                  child: const Text(
                    '確認へ進む →',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
