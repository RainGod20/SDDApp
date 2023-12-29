// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:clock_app_flutter/constants.dart';
import 'package:clock_app_flutter/models/my_theme_provider.dart';
import 'package:clock_app_flutter/screens/home_screen/components/clock_painter.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).colorScheme.background == Colors.white) {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kShadowColor.withOpacity(0.14),
                      blurRadius: 64,
                      spreadRadius: 64,
                    )
                  ],
                ),
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: CustomPaint(
                    painter: ClockPainter(context, _dateTime),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Consumer<MyThemeModel>(
              builder: (context, theme, child) => GestureDetector(
                onTap: () => theme.changeTheme(),
                child: SvgPicture.asset(
                  theme.isLightTheme ? "assets/icons/Sun.svg" : "assets/icons/Moon.svg",
                  height: 24,
                  width: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: CustomPaint(
                    painter: ClockPainter(context, _dateTime),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Consumer<MyThemeModel>(
              builder: (context, theme, child) => GestureDetector(
                onTap: () => theme.changeTheme(),
                child: SvgPicture.asset(
                  theme.isLightTheme ? "assets/icons/Sun.svg" : "assets/icons/Moon.svg",
                  height: 24,
                  width: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
