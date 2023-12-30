import 'package:clock_app_flutter/screens/pomodoro_screen/timerservice.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class timeController extends StatefulWidget {
  const timeController({super.key});

  @override
  State<timeController> createState() => _timeControllerState();
}

class _timeControllerState extends State<timeController> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerService>(context);
    return Container(
      width: getProportionateScreenWidth(112.5),
      height: getProportionateScreenWidth(112.5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconButton(
          onPressed: () {
            provider.timerPlaying
                ? Provider.of<timerService>(context, listen: false).pause()
                : Provider.of<timerService>(context, listen: false).start();
          },
          icon: provider.timerPlaying
              ? const Icon(Icons.pause_rounded)
              : const Icon(Icons.play_arrow_rounded),
          iconSize: 55,
          color: Colors.white,
        ),
      ),
    );
  }
}
