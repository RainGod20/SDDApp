import 'dart:async';

import 'package:intl/intl.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/src/location.dart';

class TimeInHourAndMinute extends StatefulWidget {
  const TimeInHourAndMinute({super.key});

  @override
  State<TimeInHourAndMinute> createState() => _TimeInHourAndMinuteState();
}

class _TimeInHourAndMinuteState extends State<TimeInHourAndMinute> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    var now = DateTime.now();
    var detroitNow = tz.TZDateTime.now(tz.getLocation('America/Detroit'));
    Map<String, Location> locationNames = tz.timeZoneDatabase.locations;

    var formattedTime = DateFormat('hh:mm').format(now);

    // String _period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    String _period = DateFormat('a').format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(
          width: 5,
        ),
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            _period,
            style: TextStyle(fontSize: getProportionateScreenWidth(18)),
          ),
        ),
      ],
    );
  }
}
