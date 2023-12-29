import 'package:clock_app_flutter/models/my_theme_provider.dart';
import 'package:clock_app_flutter/screens/location_screen/location_screen.dart';
import 'package:clock_app_flutter/screens/stopwatch_screen/stopwatch_screen.dart';
import 'package:clock_app_flutter/screens/timer_screen/timer_screen.dart';
import 'package:clock_app_flutter/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'screens/home_screen/home_screen.dart';

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyThemeModel(),
      child: Consumer<MyThemeModel>(
        builder: (context, theme, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Analog Clock',
          theme: themeData(context),
          darkTheme: darkThemeData(context),
          themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
          routes: {
            '/': (context) => HomeScreen(),
            '/location': (context) => const LocationScreen(),
            '/timer': (context) => const TimerScreen(),
            '/stopwatch': (context) => const StopwatchScreen(),
          },
        ),
      ),
    );
  }
}
