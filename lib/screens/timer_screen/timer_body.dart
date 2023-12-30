import 'package:clock_app_flutter/constants.dart';
import 'package:clock_app_flutter/models/my_theme_provider.dart';
import 'package:clock_app_flutter/screens/timer_screen/round_button.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TimerBody extends StatefulWidget {
  const TimerBody({super.key});

  @override
  State<TimerBody> createState() => _TimerBodyState();
}

class _TimerBodyState extends State<TimerBody> with TickerProviderStateMixin {
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(125),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
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
                          theme.isLightTheme
                              ? "assets/icons/Sun.svg"
                              : "assets/icons/Moon.svg",
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
          SizedBox(height: getProportionateScreenHeight(100)),
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
      ),
    );
  }
}
