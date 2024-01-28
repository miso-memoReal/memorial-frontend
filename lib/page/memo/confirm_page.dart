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
      appBar: AppBar(
        title: const Text('memoconfirm'),
      ),
      body: Column(
        children: [
          const Text("メモ内容"),
          Text(args.str),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
            child: const Center(child: Text('作成')),
          ),
        ],
      ),
    );
  }
}
