import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ScheduleDetailWidget extends StatelessWidget {
  const ScheduleDetailWidget(
      {super.key,
      required this.title,
      required this.startDate,
      required this.startTime,
      required this.endDate,
      required this.endTime,
      required this.details,
      required this.location});

  final String title;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String details;
  final String location;

  static final DateFormat _formatter = DateFormat('yyyy年MM月dd日 HH時mm分');

  // params: dateString: YYYYMMDDhhmmss
  String _formatDateFromString(String dateString) {
    int year = int.parse(dateString.substring(0, 4));
    int month = int.parse(dateString.substring(4, 6));
    int day = int.parse(dateString.substring(6, 8));
    int hour = int.parse(dateString.substring(8, 10));
    int minute = int.parse(dateString.substring(10, 12));
    int second = int.parse(dateString.substring(12, 14));
    DateTime _datetime = DateTime(year, month, day, hour, minute, second);

    return _formatter.format(_datetime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
      LabelAndText(
          label: "開始日時", text: _formatDateFromString("$startDate$startTime")),
      LabelAndText(
          label: "終了日時", text: _formatDateFromString("$endDate$endTime")),
      LabelAndText(label: "詳細", text: details),
      LabelAndText(label: "場所", text: location)
    ]);
  }
}

class LabelAndText extends StatelessWidget {
  const LabelAndText({super.key, required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Text(text, style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    );
  }
}
