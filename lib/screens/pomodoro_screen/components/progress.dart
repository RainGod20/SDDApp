import 'package:clock_app_flutter/constants.dart';
import 'package:clock_app_flutter/models/my_theme_provider.dart';
import 'package:clock_app_flutter/screens/pomodoro_screen/timerservice.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Progress extends StatelessWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerService>(context);
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${provider.set}/4",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(125),
                ),
                Text(
                  "${provider.aim}/12",
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SET',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(150),
                ),
                Text(
                  'AIM',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            )
          ],
        ),
        Positioned(
          top: 25,
          left: 0,
          right: 0,
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
      ],
    );
  }
}
