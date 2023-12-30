import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class timerService extends ChangeNotifier {
  late Timer timer;
  double currentduration = 1500;
  double selectedTime = 1500;
  bool timerPlaying = false;
  int set = 0;
  int aim = 0;
  String currentState = "FOCUS";

  void start() {
    timerPlaying = true;
    notifyListeners();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentduration == 0) {
        handleNextRound();
      } else {
        currentduration--;
        notifyListeners();
      }
    });
  }

  void pause() {
    FlutterRingtonePlayer().stop();
    timer.cancel();
    timerPlaying = false;
    notifyListeners();
  }

  void reset() {
    FlutterRingtonePlayer().stop();
    timer.cancel();
    currentState = "FOCUS";
    currentduration = selectedTime = 1500;
    set = aim = 0;
    timerPlaying = false;
    notifyListeners();
  }

  void selectTime(double seconds) {
    selectedTime = seconds;
    currentduration = seconds;
    notifyListeners();
  }

  void handleNextRound() {
    if (currentState == "LONG BREAK" && aim == 12) {
      FlutterRingtonePlayer().stop();
      FlutterRingtonePlayer().play(fromAsset: 'assets/icons/pomodoroCompleted.mp3');
      reset();
    } else if (currentState == "FOCUS" && set != 3) {
      FlutterRingtonePlayer().stop();
      FlutterRingtonePlayer().play(fromAsset: 'assets/icons/pomodoroSessionFinish.mp3');
      currentState = "BREAK";
      currentduration = 300;
      selectedTime = 300;
      set++;
      aim++;
    } else if (currentState == "BREAK") {
      FlutterRingtonePlayer().stop();
      FlutterRingtonePlayer().play(fromAsset: 'assets/icons/pomodoroSessionFinish.mp3');
      currentState = "FOCUS";
      currentduration = 1500;
      selectedTime = 1500;
    } else if (currentState == "FOCUS" && set == 3) {
      FlutterRingtonePlayer().stop();
      FlutterRingtonePlayer().play(fromAsset: 'assets/icons/pomodoroSessionFinish.mp3');
      currentState = "LONG BREAK";
      currentduration = 1500;
      selectedTime = 1500;
      set++;
      aim++;
    } else if (currentState == "LONG BREAK") {
      FlutterRingtonePlayer().stop();
      FlutterRingtonePlayer().play(fromAsset: 'assets/icons/pomodoroSessionFinish.mp3');
      currentState = "FOCUS";
      currentduration = 1500;
      selectedTime = 1500;
      set = 0;
    }
    notifyListeners();
  }
}
