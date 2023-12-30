// ignore_for_file: camel_case_types, must_be_immutable

import 'package:clock_app_flutter/screens/pomodoro_screen/components/timercard.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/timerservice.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class timerOptions extends StatelessWidget {
  List selectableTimes = [
    "1",
    "300",
    "600",
    "900",
    "1200",
    "1500",
    "1800",
    "2100",
    "2400",
    "2700",
    "3000",
    "3300",
  ];

  timerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerService>(context);
    return SingleChildScrollView(
      controller: ScrollController(initialScrollOffset: 155),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: selectableTimes.map((time) {
          return InkWell(
            onTap: () => provider.selectTime(double.parse(time)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: getProportionateScreenWidth(70),
              height: getProportionateScreenHeight(55),
              decoration: int.parse(time) == provider.selectedTime
                  ? BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15))
                  : BoxDecoration(
                      border:
                          Border.all(width: 3, color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  (int.parse(time) ~/ 60).toString(),
                  style: int.parse(time) == provider.selectedTime
                      ? TextStyle(
                          fontSize: 20,
                          color: renderColor(provider.currentState),
                        )
                      : TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
