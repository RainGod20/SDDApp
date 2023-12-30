import "dart:async";

import "package:clock_app_flutter/constants.dart";
import "package:clock_app_flutter/size_config.dart";
import "package:flutter/material.dart";

class StopwatchBody extends StatefulWidget {
  const StopwatchBody({super.key});

  @override
  State<StopwatchBody> createState() => _StopwatchBodyState();
}

class _StopwatchBodyState extends State<StopwatchBody> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  // Stop Timer Function
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  // Reset Timer Function
  void reset() {
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      laps.clear();

      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  // Add lap to timer function
  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  // Start Timer Function
  void start() {
    setState(() {
      started = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }

      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;

        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            Center(
              child: Text(
                "$digitHours:$digitMinutes:$digitSeconds",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(height: getProportionateScreenHeight(25)),
            ),
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
                boxShadow: Theme.of(context).colorScheme.background == Colors.white
                    ? [
                        BoxShadow(
                          color: kShadowColor.withOpacity(0.14),
                          blurRadius: 64,
                          spreadRadius: 64,
                        )
                      ]
                    : null,
              ),
              child: ListView.builder(
                itemCount: laps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lap Number ${index + 1}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "${laps[index]}",
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: getProportionateScreenHeight(40),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      (!started) ? start() : stop();
                    },
                    shape: StadiumBorder(
                      side: (!started)
                          ? BorderSide(color: Colors.greenAccent)
                          : BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    child: Text(
                      (!started) ? "Start" : "Pause",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  onPressed: () {
                    addLaps();
                  },
                  icon: Icon(
                    Icons.flag_rounded,
                    size: getProportionateScreenWidth(37.5),
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      reset();
                    },
                    fillColor: Theme.of(context).primaryColor,
                    shape:
                        StadiumBorder(side: BorderSide(color: Theme.of(context).primaryColor)),
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: kTitleTextLightColor, fontSize: 15),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
