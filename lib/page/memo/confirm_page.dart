import 'package:flutter/material.dart';
class ConfirmSendArguments {
  final String str;

  ConfirmSendArguments({required this.str});
}

class MemoConfirm extends StatelessWidget{
  const MemoConfirm ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ConfirmSendArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('memoconfirm'),
      ),
      body: Column(
        children: [
          const Text("メモ内容"),
          Text('${args.str}'),
          ElevatedButton(
            child:Center( child: const Text('作成')),
            style: ElevatedButton.styleFrom(
              // primary: Colors.blue,
              // onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/");
            },
          ),
        ],

      ),
    );
    // TODO: implement build
  }

}

