import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/lane_events.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';
import 'package:flutter_timetable_view/src/views/controller/timetable_view_controller.dart';
import 'package:flutter_timetable_view/src/views/diagonal_scroll_view.dart';
import 'package:flutter_timetable_view/src/views/lane_view.dart';

class TimetableView extends StatefulWidget {
  final List<LaneEvents> laneEventsList;
  final TimetableStyle timetableStyle;

  TimetableView({
    Key key,
    @required this.laneEventsList,
    this.timetableStyle: const TimetableStyle(),
  })  : assert(laneEventsList != null),
        super(key: key);

  @override
  _TimetableViewState createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView>
    with TimetableViewController {
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
    return Stack(
      children: <Widget>[
        _buildCorner(),
        _buildMainContent(context),
        _buildTimelineList(context),
        _buildLaneList(context),
      ],
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

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.timetableStyle.timeItemWidth,
        top: widget.timetableStyle.laneHeight,
      ),
      child: DiagonalScrollView(
        horizontalPixelsStreamController: horizontalPixelsStream,
        verticalPixelsStreamController: verticalPixelsStream,
        onScroll: onScroll,
        maxWidth:
            widget.laneEventsList.length * widget.timetableStyle.laneWidth,
        maxHeight:
            (widget.timetableStyle.endHour - widget.timetableStyle.startHour) *
                widget.timetableStyle.timeItemHeight,
        child: IntrinsicHeight(
          child: Row(
            children: widget.laneEventsList.map((laneEvents) {
              return LaneView(
                events: laneEvents.events,
                timetableStyle: widget.timetableStyle,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

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
          return DottedBorder(
            color: Colors.grey,
            strokeWidth: 0,
            dashPattern: [3],
            padding: EdgeInsets.all(0),
            child: Container(
              height: widget.timetableStyle.timeItemHeight,
              decoration: BoxDecoration(
                // border: Border(
                //   top: BorderSide(
                //     color: widget.timetableStyle.timelineBorderColor,
                //     width: 0,
                //   ),
                // ),
                color: widget.timetableStyle.timelineItemColor,
              ),
              child: Text(
                Utils.hourFormatter(hour, 0),
                style:
                    TextStyle(color: widget.timetableStyle.timeItemTextColor),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

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
            width: laneEvents.lane.width,
            height: laneEvents.lane.height,
            color: laneEvents.lane.backgroundColor,
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
