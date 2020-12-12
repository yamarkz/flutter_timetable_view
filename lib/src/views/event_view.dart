import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';

class EventView extends StatelessWidget {
  final TableEvent event;
  final TimetableStyle timetableStyle;

  //  Uniquely identifies which lane the event belongs to
  final int laneIndex;

  const EventView({
    Key key,
    @required this.event,
    @required this.timetableStyle,
    @required this.laneIndex
  })
      : assert(event != null),
        assert(timetableStyle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top(),
      height: height(),
      left: 0,
      width: timetableStyle.laneWidth,
      child: GestureDetector(
        onTap: () {
          event.onTap(laneIndex, event.title, event.start, event.end);
        },
        child: Container(
          decoration: event.decoration ??
              (event.backgroundColor != null
                  ? BoxDecoration(color: event.backgroundColor)
                  : null),
          margin: event.margin,
          padding: event.padding,
          child: (Utils.eventText)(
            event,
            context,
            math.max(
                0.0,
                height() -
                    (event.padding?.top ?? 0.0) -
                    (event.padding?.bottom ?? 0.0)),
            math.max(
                0.0,
                timetableStyle.laneWidth -
                    (event.padding?.left ?? 0.0) -
                    (event.padding?.right ?? 0.0)),
          ),
        ),
      ),
    );
  }

  double top() {
    return calculateTopOffset(event.start.hour, event.start.minute,
            timetableStyle.timeItemHeight) -
        timetableStyle.startHour * timetableStyle.timeItemHeight;
  }

  double height() {
    return calculateTopOffset(0, event.end.difference(event.start).inMinutes,
            timetableStyle.timeItemHeight) +
        1;
  }

  double calculateTopOffset(
    int hour, [
    int minute = 0,
    double hourRowHeight,
  ]) {
    return (hour + (minute / 60)) * (hourRowHeight ?? 60);
  }
}
