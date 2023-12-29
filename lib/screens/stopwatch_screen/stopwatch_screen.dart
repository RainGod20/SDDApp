// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:clock_app_flutter/constants.dart';
import 'package:clock_app_flutter/models/my_theme_provider.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
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

  // Reset Timer Functions
  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  // Start Timer Function
  void start() {
    started = true;
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
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                "$digitHours:$digitMinutes:$digitSeconds",
                style: Theme.of(context).textTheme.displayMedium,
              ),
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
            const SizedBox(
              height: 20,
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
                      side: BorderSide(color: Theme.of(context).primaryColor),
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
                  icon: const Icon(Icons.flag),
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Center(
        child: Text(
          'Stopwatch',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      iconTheme: Theme.of(context).iconTheme,
      actions: [buildStopwatchIcon(context)],
    );
  }

  Padding buildStopwatchIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Container(
        width: getProportionateScreenWidth(32),
        color: Colors.transparent,
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
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          DrawerHeader(
            // Icon at the top
            child: Icon(
              Icons.timer_outlined,
              size: getProportionateScreenWidth(75),
              color: Theme.of(context).iconTheme.color,
            ),
          ),

          // Homepage listTile (World Clock)
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/world.svg',
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "W O R L D    C L O C K",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              // Go to world clock page (home)
              Navigator.pushReplacementNamed(context, '/');
            },
          ),

          // Timer listTile
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/watch_2.svg',
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "T I M E R",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              // Go to world clock page (home)
              Navigator.pushReplacementNamed(context, '/timer');
            },
          ),

          // Stopwatch listTile
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/stop_watch.svg',
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "S T O P W A T C H",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              // Go to world clock page (home)
              Navigator.pushReplacementNamed(context, '/stopwatch');
            },
          ),
        ],
      ),
    );
  }
}
