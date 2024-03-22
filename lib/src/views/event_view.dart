import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';

class EventView extends StatelessWidget {
  final TableEvent event;
  final TimetableStyle timetableStyle;
  final Color statusColor;
  //  Uniquely identifies which lane the event belongs to or falls other
  final int laneIndex;

  /// Called when an event is tapped
  final void Function(TableEvent event) onEventTap;

  //TODO: Delete lane Index implementation

  const EventView(
      {Key? key,
        required this.event,
        required this.timetableStyle,
        required this.laneIndex,
        required this.onEventTap,
        required this.statusColor,

      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top(),
      height: height(),
      left: 0,
      width: timetableStyle.laneWidth,
      child: GestureDetector(
        onTap: () {
          onEventTap(event);
        },
        child: Stack(
          children: [
            // Main content of the EventView
            Container(
              decoration: event.decoration ??
                  BoxDecoration(color: event.backgroundColor),
              margin: event.margin,
              padding: event.padding,
              height :height(),
              width:timetableStyle.laneWidth,
              child: (Utils.eventText)(
                event,
                context,
                math.max(
                    0.0,
                    height() -
                        (event.padding.top) -
                        (event.padding.bottom)),
                math.max(
                    0.0,
                    timetableStyle.laneWidth -
                        (event.padding.left) -
                        (event.padding.right)),
              ),
            ),
            // Circle overlaying on the left side of the EventView
            Positioned(
              left: 1, // Positioning the circle at the very left edge
              top: 1, // Center the circle vertically
              child: Container(
                width: 16, // Adjust the size as needed
                height: 16, // Adjust the size as needed
                decoration: BoxDecoration(
                  color: statusColor, // Adjust the color as needed
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  double top() {
    return calculateTopOffset(event.startTime.hour, event.startTime.minute,
        timetableStyle.timeItemHeight) -
        timetableStyle.startHour * timetableStyle.timeItemHeight;
  }

  double height() {
    return calculateTopOffset(
        0,
        event.endTime.difference(event.startTime).inMinutes,
        timetableStyle.timeItemHeight) +
        1;
  }

  double calculateTopOffset(
      int hour, [
        int minute = 0,
        double? hourRowHeight,
      ]) {
    return (hour + (minute / 60)) * (hourRowHeight ?? 60);
  }
}
