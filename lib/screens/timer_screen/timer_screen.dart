// ignore_for_file: deprecated_member_use

import "package:clock_app_flutter/constants.dart";
import "package:clock_app_flutter/models/my_theme_provider.dart";
import "package:clock_app_flutter/screens/timer_screen/round_button.dart";
import "package:flutter/cupertino.dart";
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import "package:clock_app_flutter/size_config.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:provider/provider.dart";

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progressValue = 0;
  Duration lastDuration = const Duration(seconds: 60);

  Future<void> notify() async {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer().play(
        fromAsset: "assets/icons/ringtone.mp3",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    controller.addListener(
      () {
        notify();
        if (controller.isDismissed) {
          setState(() {
            progressValue = 1.0;
            isPlaying = false;
          });
        } else {
          setState(
            () {
              progressValue = controller.value;
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: buildAppBar(context),
      body: timerBody(context),
    );
  }

  Column timerBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: getProportionateScreenWidth(325),
                  height: getProportionateScreenWidth(325),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
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
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 6,
                    value: progressValue,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (controller.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          color: Colors.white,
                          height: 300,
                          child: CupertinoTimerPicker(
                            backgroundColor:
                                Theme.of(context).colorScheme.background == Colors.white
                                    ? Colors.white
                                    : Colors.white70,
                            initialTimerDuration: lastDuration,
                            onTimerDurationChanged: (time) {
                              setState(
                                () {
                                  controller.duration = time;
                                  lastDuration = time;
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Text(
                      countText,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
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
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (controller.isAnimating == false) {
                    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
                    setState(() {
                      isPlaying = true;
                    });
                  } else {
                    controller.stop();
                    setState(
                      () {
                        isPlaying = false;
                      },
                    );
                  }
                },
                child: RoundButton(
                  icon: isPlaying ? (Icons.pause) : Icons.play_arrow,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.reset();
                  setState(() {
                    isPlaying = false;
                  });
                },
                child: const RoundButton(
                  icon: Icons.stop,
                ),
              ),
            ],
          ),
        )
      ],
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
