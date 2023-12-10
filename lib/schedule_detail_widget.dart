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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("title: $title"),
      Text("startDate: $startDate"),
      Text("startTime: $startTime"),
      Text("endDate: $endDate"),
      Text("endTime: $endTime"),
      Text("details: $details"),
      Text("location: $location")
    ]);
  }
}
