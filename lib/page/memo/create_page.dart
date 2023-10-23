import 'package:flutter/material.dart';
import 'confirm_page.dart';

class MemoCreate extends StatefulWidget {
  @override
  _MemoCreateState createState() => _MemoCreateState();
}

class _MemoCreateState extends State<MemoCreate> {
  String argtext = ''; // メモの内容を保持する変数

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
              Navigator.pushNamed(context, "/memoConfirm",
                  arguments: ConfirmSendArguments(str: argtext));
            },
            child: const Text('確認へ進む'),
          ),
        ],
      ),
    );
  }
}
