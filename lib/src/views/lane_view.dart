import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/models/table_event_time.dart';
import 'package:flutter_timetable_view/src/styles/background_painter.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/views/event_view.dart';
List<TableEventTime> selectedItems = [];
class LaneView extends StatelessWidget {
  final List<TableEvent> events;
  final TimetableStyle timetableStyle;
  final Color statusColor;
  /// Index is used to uniquely identify each lane
  final int index;
  final bool isMultiSelectEnabled;
  final void Function(bool) onLongPressStateChanged;

  final Function(int laneIndex, TableEventTime start, TableEventTime end)
  onEmptyCellTap;

  /// Called when an event is tapped
  final void Function(TableEvent event) onEventTap;
   LaneView({
    Key? key,
    required this.events,
    required this.timetableStyle,
    required this.index,
    required this.onEmptyCellTap,
    required this.onEventTap,
    required this.statusColor,
     required this.isMultiSelectEnabled,
     required this.onLongPressStateChanged,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(),
      decoration: BoxDecoration(
        // gives each lane a vertical border
          border: Border(
            right: BorderSide(
              color: timetableStyle.timelineBorderColor,
              width: 1,
            ),
          )),
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
              onEventTap: onEventTap,
              event: event,
              timetableStyle: timetableStyle,
              laneIndex: index,
              statusColor: statusColor,
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
  ///

  _buildEmptyTimeSlots(int laneIndex) {
    List<EmptyTimeSlot> emptyTimeSlots = <EmptyTimeSlot>[];

    for (int i = timetableStyle.startHour; i < timetableStyle.endHour; i++) {
      emptyTimeSlots.add(EmptyTimeSlot(
        timetableStyle: timetableStyle,
        laneIndex: laneIndex,
        onTap: onEmptyCellTap,
        onSelectionChanged: (isSelected) {
        //  isSelected = Widget.isSelected;
        },
        onLongPressStateChanged: onLongPressStateChanged,
        start: TableEventTime(hour: i, minute: 0),
        end: TableEventTime(hour: i + 1, minute: 0),
      ));
    }


    return emptyTimeSlots;
  }
}

class EmptyTimeSlot extends StatefulWidget {
  final TimetableStyle timetableStyle;
  final int laneIndex;
  final TableEventTime start;
  final TableEventTime end;
  final Function(int laneIndex, TableEventTime start, TableEventTime end) onTap;
  final Function(bool isSelected) onSelectionChanged;
  final void Function(bool) onLongPressStateChanged;
   EmptyTimeSlot({
    Key? key,
    required this.laneIndex,
    required this.start,
    required this.end,
    required this.onTap,
    required this.onSelectionChanged,
    required this.timetableStyle,
     required this.onLongPressStateChanged,
  }) : super(key: key);

  @override
  EmptyTimeSlotState createState() => EmptyTimeSlotState();
}
bool isMultiSelectEnabled = false;

// New
class EmptyTimeSlotState extends State<EmptyTimeSlot> {
  bool isSelected = false;
  bool showLongPressMessage = false;
  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
      if (isSelected) {
        selectedItems.add(widget.start);
      } else {
        selectedItems.remove(widget.start);
      }
    });
  }




  Widget build(BuildContext context) {
    return Positioned(
      top: top(),
      height: height(),
      left: 0,
      width: widget.timetableStyle.laneWidth,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (isMultiSelectEnabled) {
                toggleSelection();
              }
              widget.onTap(widget.laneIndex, widget.start, widget.end);
            },
            onLongPress: () {
              setState(() {
                isMultiSelectEnabled = true;
                showLongPressMessage = true;
              });
              widget.onLongPressStateChanged(showLongPressMessage);
              toggleSelection();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.transparent),
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(1),
            ),
          ),

        ],
      ),
    );
  }


  double top() {
    return calculateTopOffset(
        widget.start.hour, widget.start.minute, widget.timetableStyle.timeItemHeight) -
        widget.timetableStyle.startHour * widget.timetableStyle.timeItemHeight;
  }

  double height() {
    return calculateTopOffset(
        0, widget.end.difference(widget.start).inMinutes, widget.timetableStyle.timeItemHeight) +
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