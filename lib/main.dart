import 'package:clock_app_flutter/models/my_theme_provider.dart';
import 'package:clock_app_flutter/screens/loading_screen/loading_screen.dart';
import 'package:clock_app_flutter/screens/location_screen/location_screen.dart';
import 'package:clock_app_flutter/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
              '/': (context) => LoadingScreen(),
              '/home': (context) => HomeScreen(),
              '/location': (context) => LocationScreen(),
            },
          ),
        ));
  }
}
