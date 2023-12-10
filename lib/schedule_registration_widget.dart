import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_text_to_schedule_app/openai_client.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'schedule_detail_widget.dart';

class ScheduleRegistrationWidget extends StatefulWidget {
  final String scheduleRawText;
  const ScheduleRegistrationWidget({super.key, required this.scheduleRawText});

  @override
  State<ScheduleRegistrationWidget> createState() =>
      _ScheduleRegistrationWidgetState();
}

class _ScheduleRegistrationWidgetState
    extends State<ScheduleRegistrationWidget> {
  Future<Map<String, dynamic>>? _gptResponseMapFuture;

  @override
  void initState() {
    super.initState();

    _gptResponseMapFuture = sendTextToAPI(widget.scheduleRawText);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _gptResponseMapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO: loading画面を頑張る。ワンチャン広告
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("エラー: ${snapshot.error}");
          } else {
            return snapshot.hasData
                ? Column(
                    children: [
                      ScheduleDetailWidget(
                          title: snapshot.data?["title"],
                          startDate: snapshot.data?["start_date"],
                          startTime: snapshot.data?["start_time"],
                          endDate: snapshot.data?["end_date"],
                          endTime: snapshot.data?["end_time"],
                          details: snapshot.data?["details"],
                          location: snapshot.data?["location"]),
                      ElevatedButton(
                          onPressed: () {
                            String url = generateCalendarURL(snapshot.data!);
                            if (kDebugMode) {
                              print(url);
                            } else {
                              launchUrlString(url);
                            }
                          },
                          child: const Text("カレンダーに登録"))
                    ],
                  )
                : Text("共有されたテキスト: ${widget.scheduleRawText}");
          }
        });
  }
}
