import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> sendTextToAPI(String text) async {
  String openApiKey = dotenv.get('OPENAI_API_KEY'); // FIXME: もっと頻度の低いとこで宣言できるかも

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
              "ユーザーから与えられた文章から、日程情報を抽出してください。\n\n出力は次のようなJSON形式としてください。\n\n{\n  title: string, // 予定のタイトル\n  start_date: YYYYMMDD, // 開始日\n  start_time: hhmmss, // 開始時刻\n  end_date: YYYYMMDD, // 終了日\n  end_time: hhmmss, // 終了時刻\n  details: string, // 80文字以下に要約。URLは省略しない。改行コードは\"%0A\"を用いる。\n  location: string // 開催場所\n}\n\n注意:\n* 出力にはJSON形式以外の内容を含まないでください。\n* 主催者の名称が分かればtitleに含めてください\n* location は位置が特定しやすいようにしてください"
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

  // var jsonResponse = jsonDecode(utf8.decode(response.body.codeUnits))
  //     as Map<String, dynamic>;
  var jsonResponse = {
    // mock
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
                  "日本を代表するラーメンフェス。115軒のラーメン店が参戦。五月雨式に出店店舗が入れ替わり、新しい味や好みの味に出合える。恒例のスタンプラリーも実施。",
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
  print(jsonResponse);
  // {id: chatcmpl-8SnQN9P3oF5cwh76Gg7fMMksHgtTY, object: chat.completion, created: 1701873863, model: gpt-3.5-turbo-1106, choices: [{index: 0, message: {role: assistant, content: {
  //   "title": "大つけ麺博 Presents 日本ラーメン大百科",
  //   "start_date": "20231011",
  //   "start_time": "110000",
  //   "end_date": "20231126",
  //   "end_time": "210000",
  //   "details": "日本を代表するラーメンフェス。115軒のラーメン店が参戦。五月雨式に出店店舗が入れ替わり、新しい味や好みの味に出合える。恒例のスタンプラリーも実施。",
  //   "location": "関東 東京都 新宿区 新宿・大久保公園"
  // }}, finish_reason: stop}], usage: {prompt_tokens: 803, completion_tokens: 180, total_tokens: 983}, system_fingerprint: fp_eeff13170a}

  // TODO: response のバリデーションをいれる
  var calendarParams =
      jsonDecode((jsonResponse['choices'] as List).first['message']['content'])
          as Map<String, dynamic>;

  // String urlString = generateCalendarURL(calendarParams);
  // print(urlString);
  // // https://www.google.com/calendar/event?action=TEMPLATE&trp=false&text=%E5%A4%A7%E3%81%A4%E3%81%91%E9%BA%BA%E5%8D%9A+Presents+%E6%97%A5%E6%9C%AC%E3%83%A9%E3%83%BC%E3%83%A1%E3%83%B3%E5%A4%A7%E7%99%BE%E7%A7%91&dates=20231011T110000Z%2F20231126T210000Z&location=%E9%96%A2%E6%9D%B1+%E6%9D%B1%E4%BA%AC%E9%83%BD+%E6%96%B0%E5%AE%BF%E5%8C%BA+%E6%96%B0%E5%AE%BF%E3%83%BB%E5%A4%A7%E4%B9%85%E4%BF%9D%E5%85%AC%E5%9C%92&details=%E6%97%A5%E6%9C%AC%E3%82%92%E4%BB%A3%E8%A1%A8%E3%81%99%E3%82%8B%E3%83%A9%E3%83%BC%E3%83%A1%E3%83%B3%E3%83%95%E3%82%A7%E3%82%B9%E3%80%82115%E8%BB%92%E3%81%AE%E3%83%A9%E3%83%BC%E3%83%A1%E3%83%B3%E5%BA%97%E3%81%8C%E5%8F%82%E6%88%A6%E3%80%82%E4%BA%94%E6%9C%88%E9%9B%A8%E5%BC%8F%E3%81%AB%E5%87%BA%E5%BA%97%E5%BA%97%E8%88%97%E3%81%8C%E5%85%A5%E3%82%8C%E6%9B%BF%E3%82%8F%E3%82%8A%E3%80%81%E6%96%B0%E3%81%97%E3%81%84%E5%91%B3%E3%82%84%E5%A5%BD%E3%81%BF%E3%81%AE%E5%91%B3%E3%81%AB%E5%87%BA%E5%90%88%E3%81%88%E3%82%8B%E3%80%82%E6%81%92%E4%BE%8B%E3%81%AE%E3%82%B9%E3%82%BF%E3%83%B3%E3%83%97%E3%83%A9%E3%83%AA%E3%83%BC%E3%

  // return urlString;

  return calendarParams;
}

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
  Uri url = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: 'calendar/event',
      queryParameters: formattedParams);
  // FIXME: 説明文の末尾が途切れてしまうことがある。
  return url.toString();
}
