import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_text_to_schedule_app/extract_schedule_client.dart';
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
  Future<Schedule>? _scheduleFuture;

  @override
  void initState() {
    super.initState();

    _scheduleFuture = askToAPI(widget.scheduleRawText);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Schedule>(
        future: _scheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO: loading画面を頑張る。ワンチャン広告
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("スケジュール抽出中...",
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                const CircularProgressIndicator(),
              ],
            ));
          } else if (snapshot.hasError) {
            return Text("エラー: ${snapshot.error}");
          } else {
            return snapshot.hasData
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScheduleDetailWidget(
                          title: snapshot.data!.title,
                          startDate: snapshot.data!.startDate,
                          startTime: snapshot.data!.startTime,
                          endDate: snapshot.data!.endDate,
                          endTime: snapshot.data!.endTime,
                          details: snapshot.data!.details,
                          location: snapshot.data!.location,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                              onPressed: () {
                                String url =
                                    snapshot.data!.toGoogleCalendarUrl();
                                if (kDebugMode) {
                                  print(url);
                                } else {
                                  launchUrlString(url);
                                }
                              },
                              child: const Text("カレンダーに登録")),
                        )
                      ],
                    ),
                  )
                : Text("共有されたテキスト: ${widget.scheduleRawText}");
          }
        });
  }
}
