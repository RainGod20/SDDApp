// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:clock_app_flutter/screens/home_screen/components/body.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  Map? data;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as Map?;

    SizeConfig().init(context);
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: buildAppBar(context),
      body: Body(
        data: data,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Center(
        child: Text(
          "World Clock",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      iconTheme: Theme.of(context).iconTheme,
      actions: [buildAddButton(context)],
    );
  }

  Padding buildAddButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: InkWell(
        onTap: () {
          // Navigate to Choose Clock page
          Navigator.pushNamed(context, '/location');
        },
        child: Container(
          width: getProportionateScreenWidth(32),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
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
            tileColor: Theme.of(context).colorScheme.onTertiary,
            leading: SvgPicture.asset(
              'assets/icons/world.svg',
              color: Theme.of(context).colorScheme.surface,
            ),
            title: Text(
              "W O R L D    C L O C K",
              style: Theme.of(context).textTheme.titleSmall,
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
            leading: SvgPicture.asset(
              'assets/icons/clock.svg',
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              "P O M O D O R O    T I M E R",
              style: Theme.of(context).textTheme.titleMedium,
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
