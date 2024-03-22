import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/lane_events.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/models/table_event_time.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';
import 'package:flutter_timetable_view/src/views/controller/timetable_view_controller.dart';
import 'package:flutter_timetable_view/src/views/lane_view.dart';


class TimetableView extends StatefulWidget {
  final List<LaneEvents> laneEventsList;
  final TimetableStyle timetableStyle;
  final Color statusColor;

  /// Called when an empty slot or cell is tapped must not be null
  final void Function(int laneIndex, TableEventTime start, TableEventTime end)
      onEmptySlotTap;
  final void Function(bool) onLongPressStateChanged;

  /// Called when an event is tapped
  final void Function(TableEvent event) onEventTap;
  final void Function(List<TableEvent> TableEventList) onTableEventList;
  TimetableView({
    Key? key,
    required this.laneEventsList,
    this.timetableStyle = const TimetableStyle(),
    required this.onEmptySlotTap,
    required this.onEventTap,
    required this.statusColor,
    required this.onLongPressStateChanged,
    required this.onTableEventList,
  }) : super(key: key);

  @override
  _TimetableViewState createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView>
    with TimetableViewController {
  bool isEmptyCellTapped = false;

  late int tappedEmptyCellLaneIndex;

  TableEventTime? tappedEmptyCellStartTime;

  TableEventTime? tappedEmptyCellEndTime;

  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: <Widget>[
            _buildCorner(),
            _buildMainContent(context),
            _buildTimelineList(context),
            _buildLaneList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner() {
    return Positioned(
      left: 0,
      top: 0,
      child: SizedBox(
        width: widget.timetableStyle.timeItemWidth,
        height: widget.timetableStyle.laneHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(color: widget.timetableStyle.cornerColor),
        ),
      ),
    );
  }

  /// This Draws the main Content the Lanes & Respective Events
  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.timetableStyle.timeItemWidth,
        top: widget.timetableStyle.laneHeight,
      ),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Row(
              children: widget.laneEventsList.map((laneEvent) {
                return LaneView(
                  onLongPressStateChanged: widget.onLongPressStateChanged,
                  statusColor: widget.statusColor,
                  events: laneEvent.events,
                  timetableStyle: widget.timetableStyle,
                  index: widget.laneEventsList.indexOf(laneEvent),
                  onEventTap: (TableEvent event){

                  },
                  onEmptyCellTap: (laneIndex, startTime, endTime) {
                    setState(() {
                      isEmptyCellTapped = true;
                      tappedEmptyCellLaneIndex = laneIndex;
                      tappedEmptyCellStartTime = startTime;
                      tappedEmptyCellEndTime = endTime;
                    });

                  }, onTableEventList: (List<TableEvent> TableEventList) {
                  widget.onTableEventList(TableEventList);
                }
                );
              }).toList(),
            ),
            isEmptyCellTapped
                ? _buildEmptyTimeSlot(
                    tappedEmptyCellLaneIndex,
                    tappedEmptyCellStartTime!,
                    tappedEmptyCellEndTime!,
                  )
                // EmptyTimeSlot(
                //   widget.timetableStyle,
                //         dayOfWeek: tappedEmptyCellDayOfWeek,
                //         laneIndex: tappedEmptyCellLaneIndex,
                //         start: tappedEmptyCellStartTime,
                //         end: tappedEmptyCellEndTime,
                //         onTap: widget.onEmptySlotTap,
                //       )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),

            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: FloatingActionButton(
            //     onPressed: () {
            //       // Handle FAB press
            //     },
            //     child: Icon(Icons.add),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _buildEmptyTimeSlot(
    // final TimetableStyle timetableStyle,
    final int laneIndex,
    final TableEventTime start,
    final TableEventTime end,
  ) {
    double calculateTopOffset(
      int hour, [
      int minute = 0,
      double? hourRowHeight,
    ]) {
      return (hour + (minute / 60)) * (hourRowHeight ?? 60);
    }

    double top() {
      return calculateTopOffset(
              start.hour, start.minute, widget.timetableStyle.timeItemHeight) -
          (widget.timetableStyle.startHour *
              widget.timetableStyle.timeItemHeight);
    }

    double height() {
      return calculateTopOffset(0, 60, widget.timetableStyle.timeItemHeight) +
          1;
    }

    return Positioned(
      top: top(),
      height: height(),
      left: (widget.timetableStyle.laneWidth * laneIndex),
      width: widget.timetableStyle.laneWidth,
      child: GestureDetector(
        onTap: () {
          widget.onEmptySlotTap(laneIndex, start, end);
          setState(() {
            isEmptyCellTapped = false;
          });
        },
        child: Opacity(
          opacity: 0.5,
          child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.all(1),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the TimeLine on the Left from start Hour to endHour
  Widget _buildTimelineList(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: widget.timetableStyle.timeItemWidth,
      padding: EdgeInsets.only(top: widget.timetableStyle.laneHeight),
      color: widget.timetableStyle.timelineColor,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        controller: verticalScrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          for (var i = widget.timetableStyle.startHour;
              i < widget.timetableStyle.endHour;
              i += 1)
            i
        ].map((hour) {
          return Container(
            height: widget.timetableStyle.timeItemHeight,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: widget.timetableStyle.timelineBorderColor,
                  width: 0,
                ),
                right: BorderSide(
                  color: widget.timetableStyle.timelineBorderColor,
                  width: 1,
                ),
              ),
              color: widget.timetableStyle.timelineItemColor,
            ),
            child: Container(
              alignment: widget.timetableStyle.timeItemAlignment,
              child: Text(
                Utils.hourFormatter(
                    hour, 0, widget.timetableStyle.showTimeAsAMPM),
                style: TextStyle(
                    color: widget.timetableStyle.timeItemTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Builds the Lane Headers / The Lane Labels
  Widget _buildLaneList(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: widget.timetableStyle.laneColor,
      height: widget.timetableStyle.laneHeight,
      padding: EdgeInsets.only(left: widget.timetableStyle.timeItemWidth),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        controller: horizontalScrollController,
        shrinkWrap: true,
        children: widget.laneEventsList.map((laneEvents) {
          return Container(
            width: widget.timetableStyle.laneWidth,
            height: laneEvents.lane.height,
            color: laneEvents.lane.backgroundColor,
            // color: Colors.red,
            child: Center(
              child: Text(
                laneEvents.lane.name,
                style: laneEvents.lane.textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
