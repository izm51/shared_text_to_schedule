import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
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
    String openApiKey =
        dotenv.get('OPENAI_API_KEY'); // FIXME: もっと頻度の低いとこで宣言できるかも

    var response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openApiKey',
        'Content-Type': 'application/json'
        // 'OpenAI-Organization': 'org-aG64VeI3xGVgfoFNU61a18op'
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo-1106",
        "response_format": {"type": "json_object"},
        "messages": [
          {
            "role": "system",
            "content":
                "ユーザーから与えられた文章から、日程情報を抽出してください。\n\n出力は次のようなJSON形式としてください。\n\n{\n  title: string, // 予定のタイトル\n  start_date: YYYYMMDD, // 開始日\n  start_time: hhmmss, // 開始時刻\n  end_date: YYYYMMDD, // 終了日\n  end_time: hhmmss, // 終了時刻\n  details: string, // 文章の要約。URLは省略しない。改行コードは\"%0A\"を用いる。\n  location: string // 開催場所\n}\n\n注意:\n* 出力にはJSON形式以外の内容を含まないでください。\n* 主催者の名称が分かればtitleに含めてください\n* location は詳しい名称を含めてください"
          },
          {"role": "user", "content": text},
        ],
        "temperature": 1,
        "max_tokens": 512,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0
      }),
    );

    var jsonResponse = jsonDecode(utf8.decode(response.body.codeUnits))
        as Map<String, dynamic>;

    return (jsonResponse['choices'] as List).first['message']['content']
        as String;
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
