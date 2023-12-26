import 'dart:ffi';

import 'package:clock_app_flutter/screens/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void setupWorldTime() async {
    print("got to setupWorldTime");
    WorldTime instance = WorldTime(flag: 'germany.png', url: 'Europe/Berlin');
    print("started instance.getTime()");
    await instance.getTime();
    print("Finished instance.getTime()");
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'countryAndCity': instance.countryAndCity,
      'offsetAndAbbrev': instance.offsetAndAbbrev,
      'flag': instance.flag,
      'time': instance.time,
      'period': instance.period,
    });
    print("finished setupWorldTime");
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Text('Loading'),
      ),
    );
  }
}
