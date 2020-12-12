import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/styles/background_painter.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/views/event_view.dart';

class LaneView extends StatelessWidget {
  final List<TableEvent> events;
  final TimetableStyle timetableStyle;

  /// Index is used to uniquely identify each lane
  final int index;
  final Function(int laneIndex, TableEventTime start, TableEventTime end)
      onEmptyCellTap;

  const LaneView({
    Key key,
    @required this.events,
    @required this.timetableStyle,
    @required this.index,
    @required this.onEmptyCellTap,
  })  : assert(events != null),
        assert(timetableStyle != null),
        assert(onEmptyCellTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(),
      width: timetableStyle.laneWidth,
      child: Stack(
        children: [
          ...[
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(
                  timetableStyle: timetableStyle,
                ),
              ),
            )
          ],
          // draw the empty time slots before you draw the events.
          ..._buildEmptyTimeSlots(index),
          ...events.map((event) {
            return EventView(
              event: event,
              timetableStyle: timetableStyle,
              laneIndex: index,
            );
          }).toList(),
        ],
      ),
    );
  }

  double height() {
    return (timetableStyle.endHour - timetableStyle.startHour) *
        timetableStyle.timeItemHeight;
  }

  /// Draws the Empty Time Slot for each Lane
  _buildEmptyTimeSlots(int laneIndex) {
    List<_EmptyTimeSlot> emptyTimeSlots = <_EmptyTimeSlot>[];

    // I don't know if this is performant but i cant think of something else for now
    for (int i = timetableStyle.startHour; i < timetableStyle.endHour; i++) {
      emptyTimeSlots.add(_EmptyTimeSlot(
        timetableStyle,
        laneIndex: laneIndex,
        onTap: onEmptyCellTap,
        start: TableEventTime(hour: i, minute: 0),
        end: TableEventTime(hour: i + 1, minute: 0),
      ));
    }

    return emptyTimeSlots;
  }
}

class _EmptyTimeSlot extends StatelessWidget {
  final TimetableStyle timetableStyle;
  final int laneIndex;
  final TableEventTime start;
  final TableEventTime end;
  final Function(int laneIndex, TableEventTime start, TableEventTime end) onTap;

  _EmptyTimeSlot(this.timetableStyle,
      {this.laneIndex, this.start, this.end, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top(),
      height: height(),
      left: 0,
      width: timetableStyle.laneWidth,
      child: GestureDetector(
        onTap: () {
          onTap(laneIndex, start, end);
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.all(1),
        ),
      ),
    );
  }

  double top() {
    return calculateTopOffset(
        start.hour, start.minute, timetableStyle.timeItemHeight) -
        timetableStyle.startHour * timetableStyle.timeItemHeight;
  }

  double height() {
    return calculateTopOffset(0, end
        .difference(start)
        .inMinutes, timetableStyle.timeItemHeight) + 1;
  }

  double calculateTopOffset(int hour, [
    int minute = 0,
    double hourRowHeight,
  ]) {
    return (hour + (minute / 60)) * (hourRowHeight ?? 60);
  }
}
