import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shared Data Example',
      home: SharedDataScreen(),
    );
  }
}

class SharedDataScreen extends StatefulWidget {
  @override
  _SharedDataScreenState createState() => _SharedDataScreenState();
}

class _SharedDataScreenState extends State<SharedDataScreen> {
  String _sharedText = '';
  Future<String>? _responseFuture;

  @override
  void initState() {
    super.initState();

    // リアルタイムで共有されたテキストを取得
    ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        _responseFuture = sendTextToAPI(value);
      });
    }, onError: (err) {
      print("エラー: $err");
    });

    // 初期共有テキストを取得
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        setState(() {
          _sharedText = value;
          _responseFuture = sendTextToAPI(value);
        });
      }
    });
  }

  Future<String> sendTextToAPI(String text) async {
    // ここでAPIリクエストを行います。適切なURLとパラメーターを指定してください。
    var response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/1'),
      // body: {'text': text},
    );
    return response.body; // APIからのレスポンスを返します
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Data'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _responseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("エラー: ${snapshot.error}");
            } else {
              return snapshot.hasData
                  ? Text("APIレスポンス: ${snapshot.data}")
                  : Text("共有されたテキスト: $_sharedText");
            }
          },
        ),
      ),
    );
  }
}
