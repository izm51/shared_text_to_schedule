import 'package:flutter/material.dart';

class ScheduleRegistrationWidget extends StatefulWidget {
  final String scheduleRawText;
  const ScheduleRegistrationWidget({super.key, required this.scheduleRawText});

  @override
  State<ScheduleRegistrationWidget> createState() =>
      _ScheduleRegistrationWidgetState();
}

class _ScheduleRegistrationWidgetState
    extends State<ScheduleRegistrationWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.scheduleRawText);
  }
}
