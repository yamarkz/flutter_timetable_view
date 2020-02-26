import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final Color backgroundColor;

  final Color rulesColor;

  BackgroundPainter({
    this.backgroundColor,
    this.rulesColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor,
      );
    }

    if (rulesColor != null) {
      for (int hour = 1; hour < 24; hour++) {
        double topOffset = topOffsetCalculator(hour);
        canvas.drawLine(
          Offset(0, topOffset),
          Offset(size.width, topOffset),
          Paint()..color = rulesColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDayViewBackgroundPainter) {
    return backgroundColor != oldDayViewBackgroundPainter.backgroundColor ||
        rulesColor != oldDayViewBackgroundPainter.rulesColor;
  }

  static double topOffsetCalculator(int hour) => hour * 60.0;
}
