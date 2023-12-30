import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final BuildContext context;
  final DateTime dateTime;

  ClockPainter(this.context, this.dateTime);
  @override
  void paint(Canvas canvas, Size size) {
    double centreX = size.width / 2;
    double centreY = size.height / 2;
    Offset center = Offset(centreX, centreY);

    // Minute Hand Calculations
    double minX = centreX + size.width * 0.375 * cos((dateTime.minute * 6) * pi / 180);
    double minY = centreY + size.width * 0.375 * sin((dateTime.minute * 6) * pi / 180);

    // Minute Hand
    canvas.drawLine(
      center,
      Offset(minX, minY),
      Paint()
        ..color = Theme.of(context).colorScheme.onSecondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    // Hour Hand Calculations
    // dateTime.hour * 30 + dateTime.minute * 0.5 because 360 (degrees) / 12 (hours in day) = 30
    //and 30 (degrees between hours) / 60 (minutes in hour) = 0.5
    double hourX = centreX +
        size.width * 0.2825 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourY = centreY +
        size.width * 0.2825 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);

    // Hour Hand
    canvas.drawLine(
      center,
      Offset(hourX, hourY),
      Paint()
        ..color = Theme.of(context).colorScheme.onSecondaryContainer
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    // Second Hand Calculations
    // Size.width * 0.31 determines length of line
    // Datetime.second * 6 because 360 (degrees) / 60 (seconds in a minute) = 6
    double secondX = centreX + size.width * 0.4125 * cos((dateTime.second * 6) * pi / 180);
    double secondY = centreY + size.width * 0.4125 * sin((dateTime.second * 6) * pi / 180);

    // Second Hand
    canvas.drawLine(
        center,
        Offset(secondX, secondY),
        Paint()
          ..color = Theme.of(context).primaryColor
          ..strokeWidth = 1.5);

    // Center Dot
    Paint dotPainter = Paint()..color = Theme.of(context).primaryIconTheme.color!;
    canvas.drawCircle(center, 24, dotPainter);
    canvas.drawCircle(center, 23, Paint()..color = Theme.of(context).colorScheme.background);
    canvas.drawCircle(center, 10, dotPainter);

    // External Lines
    for (int i = 0; i < 60; i++) {
      // Calculate line position
      double minute = (6 * i).toDouble();

      // Set style every 5 min
      Paint externalLinePainter = Paint()
        ..color = (i % 5 == 0)
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSecondaryContainer
        ..strokeWidth = (i % 5 == 0) ? 4 : 1.5;

      int distance = (i % 5 == 0) ? 35 : 50;

      double x1 = (size.width / 2) + (size.width / 3 + distance) * cos(minute * pi / 180);
      double y1 = (size.height / 2) + (size.width / 3 + distance) * sin(minute * pi / 180);

      double x2 = (size.width / 2) + (size.width / 3 + 57.5) * cos(minute * pi / 180);
      double y2 = (size.height / 2) + (size.width / 3 + 57.5) * sin(minute * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), externalLinePainter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
