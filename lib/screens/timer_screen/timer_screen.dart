// ignore_for_file: deprecated_member_use

import "package:clock_app_flutter/screens/timer_screen/timer_body.dart";
import "package:clock_app_flutter/size_config.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: buildAppBar(context),
      body: TimerBody(),
    );
  }

  Padding buildTimerIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Container(
        width: getProportionateScreenWidth(32),
        color: Colors.transparent,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          'Timer',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      iconTheme: Theme.of(context).iconTheme,
      actions: [buildTimerIcon(context)],
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
              color: Theme.of(context).colorScheme.onSecondary,
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
            tileColor: Theme.of(context).colorScheme.onTertiary,
            leading: SvgPicture.asset(
              'assets/icons/watch_2.svg',
              color: Theme.of(context).colorScheme.surface,
            ),
            title: Text(
              "T I M E R",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () {
              // Go to timer page
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
              // Go to stopwatch page
              Navigator.pushReplacementNamed(context, '/stopwatch');
            },
          ),
        ],
      ),
    );
  }
}
