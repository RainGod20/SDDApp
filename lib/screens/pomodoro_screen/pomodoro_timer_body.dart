import 'package:clock_app_flutter/screens/pomodoro_screen/components/progress.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/components/timecontroller.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/components/timercard.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/components/timeroptions.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class PomodoroTimerBody extends StatelessWidget {
  const PomodoroTimerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            const TimerCard(),
            SizedBox(
              height: getProportionateScreenHeight(45),
            ),
            timerOptions(),
            SizedBox(
              height: getProportionateScreenHeight(75),
            ),
            const timeController(),
            SizedBox(
              height: getProportionateScreenHeight(60),
            ),
            const Progress()
          ],
        ),
      ),
    );
  }
}
