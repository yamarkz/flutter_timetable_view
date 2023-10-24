import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/models/table_event_time.dart';
import 'package:flutter_timetable_view/src/styles/background_painter.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/views/event_view.dart';

bool isMultiSelectEnabled = false;

class LaneView extends StatefulWidget {
  final List<TableEvent> events;
  final TimetableStyle timetableStyle;
  final Color statusColor;
  /// Index is used to uniquely identify each lane
  final int index;
  final void Function(bool) onLongPressStateChanged;

  final Function(int laneIndex, TableEventTime start, TableEventTime end)
      onEmptyCellTap;

  /// Called when an event is tapped
  final void Function(TableEvent event) onEventTap;
  final void Function(List<TableEvent> TableEventList) onTableEventList;


   LaneView({
    Key? key,
    required this.events,
    required this.timetableStyle,
    required this.index,
    required this.onEmptyCellTap,
    required this.onEventTap,
    required this.statusColor,
    required this.onLongPressStateChanged,
    required this.onTableEventList,
  }) : super(key: key);

  @override
  State<LaneView> createState() => LaneViewState();
}
List<TableEvent> selectedEvents = [];
class LaneViewState extends State<LaneView> {


  void addEvent(TableEvent event) {
    if (isMultiSelectEnabled) {
      if (!selectedEvents.contains(event)) {
        if (!widget.events.contains(event)) {
          setState(() {
            widget.events.add(event);
          });
        }
       selectedEvents.add(event);
      }
    }
    widget.onTableEventList(selectedEvents);
  }

  void removeEvent(TableEvent event) {
    if (isMultiSelectEnabled && selectedEvents.contains(event)) {
      selectedEvents.remove(event);
      setState(() {
        widget.events.remove(event);
      });
    } else if (!isMultiSelectEnabled) {
      widget.onEventTap(event);
    }
    widget.onTableEventList(selectedEvents);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(),
      decoration: BoxDecoration(
          // gives each lane a vertical border
          border: Border(
        right: BorderSide(
          color: widget.timetableStyle.timelineBorderColor,
          width: 1,
        ),
      )),
      width: widget.timetableStyle.laneWidth,
      child: Stack(
        children: [
          ...[
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(
                  timetableStyle: widget.timetableStyle,
                ),
              ),
            )
          ],
          // draw the empty time slots before you draw the events.
          ..._buildEmptyTimeSlots(widget.index),
          ...widget.events.map((event) {
            return EventView(
              onEventTap: removeEvent,
              event: event,
              timetableStyle: widget.timetableStyle,
              laneIndex: widget.index,
              statusColor: widget.statusColor,
            );
          }).toList(),
        ],
      ),
    );
  }

  double height() {
    return (widget.timetableStyle.endHour - widget.timetableStyle.startHour) *
        widget.timetableStyle.timeItemHeight;
  }

  /// Draws the Empty Time Slot for each Lane
  ///

  _buildEmptyTimeSlots(int laneIndex) {
    List<EmptyTimeSlot> emptyTimeSlots = <EmptyTimeSlot>[];

    for (int i = widget.timetableStyle.startHour;
        i < widget.timetableStyle.endHour;
        i++) {
      emptyTimeSlots.add(EmptyTimeSlot(
        timetableStyle: widget.timetableStyle,
        laneIndex: laneIndex,
        onTap: widget.onEmptyCellTap,
        onSelectionChanged: (isSelected) {
          //  isSelected = Widget.isSelected;
        },
        onLongPressStateChanged: widget.onLongPressStateChanged,
        start: TableEventTime(hour: i, minute: 0),
        end: TableEventTime(hour: i + 1, minute: 0),
      ));
    }

    // You can now access the `events` list from here.
    // For example, you could use it to filter the empty time slots based on the events.

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

// New
class EmptyTimeSlotState extends State<EmptyTimeSlot> {
  void toggleSelection() {
    TableEvent newEvent = convertToTableEvent(widget.start, widget.end);
    if (selectedEvents.contains(newEvent) ?? false) {
      context.findAncestorStateOfType<LaneViewState>()?.removeEvent(newEvent);
    } else {
      context.findAncestorStateOfType<LaneViewState>()?.addEvent(newEvent);
    }
  }



  TableEvent convertToTableEvent(TableEventTime start, TableEventTime end) {
    // Create a unique ID for the event based on its start and end times.
    int eventId = (start.hour * 60 + start.minute) +
        (end.hour * 60 + end.minute) +
        start.microsecond;
    return TableEvent(
      title: '',
      eventId: eventId,
      laneIndex: widget.laneIndex, // Use the actual lane index
      startTime: start,
      endTime: end,
    );
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
                toggleSelection();  // This handles the selection/deselection in multi-select mode
              } else {
                widget.onTap(widget.laneIndex, widget.start, widget.end);
              }
            },

            onLongPress: () {
              setState(() {
                isMultiSelectEnabled = !isMultiSelectEnabled;
              });
           selectedEvents.clear();
              widget.onLongPressStateChanged(isMultiSelectEnabled);
            },


            child: Container(
              decoration: BoxDecoration(color: Colors.transparent),
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(1),
            ),
          ),
        ],
      ),
    );
  }

  double top() {
    return calculateTopOffset(widget.start.hour, widget.start.minute,
            widget.timetableStyle.timeItemHeight) -
        widget.timetableStyle.startHour * widget.timetableStyle.timeItemHeight;
  }

  double height() {
    return calculateTopOffset(0, widget.end.difference(widget.start).inMinutes,
            widget.timetableStyle.timeItemHeight) +
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
