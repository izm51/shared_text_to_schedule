import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

const bool useMock = false;

const mockResponse = {
  "title": "大つけ麺博 Presents 日本ラーメン大百科",
  "startDate": "20231011",
  "startTime": "110000",
  "endDate": "20231126",
  "endTime": "210000",
  "details": "日本を代表するラーメンフェス。115軒のラーメン店が参戦。",
  "location": "関東 東京都 新宿区 新宿・大久保公園",
};

Future<Schedule> askToAPI(String text) async {
  try {
    Map<String, dynamic> res;

    if (!useMock) {
      if (kDebugMode) {
        print("useFunctionsEmulator");
        FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
      }
      final result = await FirebaseFunctions.instance
          .httpsCallable('extractSchedule')
          .call({"text": text});
      res = result.data as Map<String, dynamic>;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      res = mockResponse;
    }

    return Schedule(res["title"], res["startDate"], res["startTime"],
        res["endDate"], res["endTime"], res["details"], res["location"]);
  } catch (e) {
    print("askToAPI error: $e");
    return Future.error(e);
  }
}

// TODO: モデルとして外に出ししたい
class Schedule {
  final String title;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String details;
  final String location;

  Schedule(this.title, this.startDate, this.startTime, this.endDate,
      this.endTime, this.details, this.location);

  String toGoogleCalendarUrl() {
    Map<String, dynamic> urlParams = {
      "action": "TEMPLATE",
      "trp": "false",
      "text": title,
      "dates": "${startDate}T$startTime/${endDate}T$endTime",
      "location": location,
      "details": details
    };
    // FIXME: 説明文の末尾が途切れてしまうことがあるかも
    Uri url = Uri.https('www.google.com', 'calendar/event', urlParams);
    return url.toString();
  }
}
