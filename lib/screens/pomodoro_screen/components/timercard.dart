import 'package:clock_app_flutter/constants.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/timerservice.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerService>(context);
    return Column(
      children: [
        Text(
          provider.currentState,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            fontStyle: Theme.of(context).textTheme.titleLarge?.fontStyle,
            color: renderColor(provider.currentState),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(40),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.2,
              height: getProportionateScreenHeight(187.5),
              decoration: BoxDecoration(
                  color: kAccentLightColor,
                  borderRadius: BorderRadiusDirectional.circular(15),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: kAccentLightColor.withOpacity(0.8),
                        spreadRadius: 2.5,
                        offset: const Offset(0, 2)),
                  ]),
              child: Center(
                child: Text(
                  (provider.currentduration ~/ 60).toString(),
                  style: TextStyle(
                      color: renderColor(provider.currentState),
                      fontSize: 70,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(15),
            ),
            Text(
              ':',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              width: getProportionateScreenWidth(15),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3.2,
              height: getProportionateScreenHeight(187.5),
              decoration: BoxDecoration(
                  color: kAccentLightColor,
                  borderRadius: BorderRadiusDirectional.circular(15),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: kAccentLightColor.withOpacity(0.8),
                        spreadRadius: 2.5,
                        offset: const Offset(0, 2)),
                  ]),
              child: Center(
                child: Text(
                  DateFormat("ss").format(DateTime(
                      0, 0, 0, 0, 0, (provider.currentduration % 60).round().toInt())),
                  style: TextStyle(
                    color: renderColor(provider.currentState),
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

Color renderColor(String currentState) {
  if (currentState == "FOCUS") {
    return Colors.redAccent;
  } else {
    return Colors.greenAccent[400]!;
  }
}
