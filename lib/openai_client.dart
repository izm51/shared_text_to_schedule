import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String openApiKey = dotenv.get('OPENAI_API_KEY'); // FIXME: もっと頻度の低いとこで宣言できるかも
const bool useMock = false;

Future<Map<String, dynamic>> sendTextToAPI(String text) async {
  Map<String, dynamic> jsonResponse;

  if (!useMock) {
    var response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openApiKey',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo-1106",
        "response_format": {"type": "json_object"},
        "messages": [
          {
            "role": "system",
            "content":
                "ユーザーから与えられた文章から、日程情報を抽出してください。\n\n出力は次のようなJSON形式としてください。\n\n{\n  title: string, // 予定のタイトル\n  start_date: YYYYMMDD, // 開始日\n  start_time: hhmmss, // 開始時刻\n  end_date: YYYYMMDD, // 終了日\n  end_time: hhmmss, // 終了時刻\n  details: string, // 60文字程度で要約。URLは省略しない。改行コードは\"%0A\"を用いる。\n  location: string // 開催場所\n}\n\n注意:\n* 出力にはJSON形式以外の内容を含まないでください。\n* 主催者の名称が分かればtitleに含めてください\n* location は位置が特定しやすいようにしてください"
          },
          {"role": "user", "content": text},
        ],
        "temperature": 1,
        "max_tokens": 256,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0
      }),
    );
    jsonResponse = jsonDecode(utf8.decode(response.body.codeUnits))
        as Map<String, dynamic>;
  } else {
    await new Future.delayed(new Duration(seconds: 1));
    // mock
    jsonResponse = {
      "id": "chatcmpl-8SnQN9P3oF5cwh76Gg7fMMksHgtTY",
      "object": "chat.completion",
      "created": 1701873863,
      "model": "gpt-3.5-turbo-1106",
      "choices": [
        {
          "index": 0,
          "message": {
            "role": "assistant",
            "content": """{
                "title": "大つけ麺博 Presents 日本ラーメン大百科",
                "start_date": "20231011",
                "start_time": "110000",
                "end_date": "20231126",
                "end_time": "210000",
                "details":
                    "日本を代表するラーメンフェス。115軒のラーメン店が参戦。",
                "location": "関東 東京都 新宿区 新宿・大久保公園"
              }"""
          },
          "finish_reason": "stop"
        }
      ],
      "usage": {
        "prompt_tokens": 803,
        "completion_tokens": 180,
        "total_tokens": 983
      },
      "system_fingerprint": "fp_eeff13170a"
    };
  }

  print(jsonResponse);

  // TODO: response のバリデーションをいれる (キーが一致しないときの修復)
  var calendarParams =
      jsonDecode((jsonResponse['choices'] as List).first['message']['content'])
          as Map<String, dynamic>;

  return calendarParams;
}

// TODO: 引数の型ちゃんとする
String generateCalendarURL(Map<String, dynamic> params) {
  Map<String, dynamic> formattedParams = {
    "action": "TEMPLATE",
    "trp": "false",
    "text": params["title"],
    "dates":
        "${params['start_date']}T${params['start_time']}Z/${params['end_date']}T${params['end_time']}Z",
    "location": params["location"],
    "details": params["details"]
  };
  // FIXME: 説明文の末尾が途切れてしまうことがある。
  Uri url = Uri.https('www.google.com', 'calendar/event', formattedParams);
  return url.toString();
}
