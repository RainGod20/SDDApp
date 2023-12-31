// ignore_for_file: unused_local_variable

import 'package:clock_app_flutter/models/my_theme_provider.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/pomodoro_timer_body.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/timerservice.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PomodoroTimerScreen extends StatelessWidget {
  const PomodoroTimerScreen({super.key});
  Color renderColor(String currentState) {
    if (currentState == "FOCUS") {
      return Colors.redAccent;
    } else {
      return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerService>(context);
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: buildAppBar(context),
      body: PomodoroTimerBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Center(
        child: Text(
          'Pomodoro Timer',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      iconTheme: Theme.of(context).iconTheme,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          iconSize: 40,
          color: Theme.of(context).colorScheme.onSecondary,
          onPressed: () => Provider.of<timerService>(context, listen: false).reset(),
        ),
      ],
    );
  }

  Padding buildPomodoroTimerIcon(BuildContext context) {
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
            leading: Icon(
              Icons.hourglass_empty_rounded,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "T I M E R",
              style: Theme.of(context).textTheme.titleMedium,
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

          // Pomodoro Timer listTile
          ListTile(
            tileColor: Theme.of(context).colorScheme.onTertiary,
            leading: SvgPicture.asset(
              'assets/icons/clock.svg',
              color: Theme.of(context).colorScheme.surface,
            ),
            title: Text(
              "P O M O D O R O    T I M E R",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () {
              // Go to Pomodoro Timer page
              Navigator.pushReplacementNamed(context, '/pomodoro');
            },
          ),
        ],
      ),
    );
  }
}
