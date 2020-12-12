import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TimeTable View Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timetable View Demo'),
      ),
      body: TimetableView(
        laneEventsList: _buildLaneEvents(),
        timetableStyle: TimetableStyle(),
        onEmptySlotTap:
            (int laneIndex, TableEventTime start, TableEventTime end) {
          print(
              "Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
        },
      ),
    );
  }

  List<LaneEvents> _buildLaneEvents() {
    return [
      LaneEvents(
        lane: Lane(name: 'Track A'),
        events: [
          TableEvent(
            title: 'An event 1',
            onTap: onEventCallBack,
            start: TableEventTime(hour: 8, minute: 0),
            end: TableEventTime(hour: 10, minute: 0),
          ),
          TableEvent(
            title: 'An event 2',
            onTap: onEventCallBack,
            start: TableEventTime(hour: 12, minute: 0),
            end: TableEventTime(hour: 13, minute: 20),
          ),
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Track B'),
        events: [
          TableEvent(
            title: 'An event 3',
            onTap: onEventCallBack,
            start: TableEventTime(hour: 10, minute: 10),
            end: TableEventTime(hour: 11, minute: 45),
          ),
        ],
      ),
    ];
  }

  void onEventCallBack(
      int laneIndex, String title, TableEventTime start, TableEventTime end) {
    print(
        "Event Clicked!! LaneIndex $laneIndex Title: $title StartHour: ${start.hour} EndHour: ${end.hour}");
  }
}
