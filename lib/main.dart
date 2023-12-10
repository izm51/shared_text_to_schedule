// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'schedule_registration_widget.dart';

// TODO: webサイトも受け取れるように
// TODO: 画像も受け取れるように
// TODO: 最低限、デザインも便利に
Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Shared Data Example',
      home: SharedDataScreen(),
    );
  }
}

class SharedDataScreen extends StatefulWidget {
  const SharedDataScreen({super.key});

  @override
  State<SharedDataScreen> createState() => _SharedDataScreenState();
}

class _SharedDataScreenState extends State<SharedDataScreen> {
  String _sharedText = '';

  @override
  void initState() {
    super.initState();

    // リアルタイムで共有されたテキストを取得
    ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      print("エラー: $err");
    });

    // 初期共有テキストを取得
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        setState(() {
          _sharedText = value;
        });
      }
    }, onError: (err) {
      print("エラー: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Data'),
      ),
      body: Center(
          child: _sharedText.isNotEmpty
              ? ScheduleRegistrationWidget(scheduleRawText: _sharedText)
              : const Text('テキストを共有してください')),
    );
  }
}
