import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';

class BackgroundPainter extends CustomPainter {
  final TimetableStyle timetableStyle;

  BackgroundPainter({
    this.timetableStyle,
  }) : assert(timetableStyle != null);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = timetableStyle.mainBackgroundColor,
    );
    for (int hour = 1; hour < 24; hour++) {
      double topOffset = calculateTopOffset(hour);
      canvas.drawLine(
        Offset(0, topOffset),
        Offset(size.width, topOffset),
        Paint()..color = timetableStyle.timelineBorderColor,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDayViewBackgroundPainter) {
    return (timetableStyle.mainBackgroundColor !=
            oldDayViewBackgroundPainter.timetableStyle.mainBackgroundColor ||
        timetableStyle.timelineBorderColor !=
            oldDayViewBackgroundPainter.timetableStyle.timelineBorderColor);
  }

  double calculateTopOffset(int hour) => hour * timetableStyle.timeItemHeight;
}
