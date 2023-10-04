import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

void main() {
runApp(MyApp());
}

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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TimetableView(
        isMultiSelectEnabled: false,
        selectedItems: (List<TableEventTime>? TableEventTimeList){
          print(TableEventTimeList);
        },
        statusColor: Colors.pink,
        timetableStyle: TimetableStyle(laneWidth: 100,mainBackgroundColor: Colors.black12,),
        laneEventsList: [
          LaneEvents(
              lane: Lane(
                name: 'زمین ۱',
                laneIndex: 0,
              ),
              events: [
                TableEvent(
                  title: 'An event 1',
                  eventId: 1,
                  price: '43',
                  laneIndex: 1,
                  startTime: TableEventTime(hour: 10, minute: 0),
                  endTime: TableEventTime(hour: 11, minute: 20),
                ),
              ]),
          LaneEvents(
              lane: Lane(
                name: 'زمین ۲',
                laneIndex: 0,
              ),
              events: [
                TableEvent(
                  title: 'An event 1',

                  eventId: 1,
                  price: '43',
                  laneIndex: 1,
                  startTime: TableEventTime(hour: 10, minute: 0),
                  endTime: TableEventTime(hour: 10, minute: 59),
                ),
              ]),


          LaneEvents(
              lane: Lane(
                name: 'زمین ۶',
                laneIndex: 0,
              ),
              events: [
                TableEvent(
                  title: 'An event 1',

                  eventId: 1,
                  price: '43',
                  laneIndex: 1,
                  startTime: TableEventTime(hour: 10, minute: 0),
                  endTime: TableEventTime(hour: 11, minute: 20),
                ),
              ]),
          LaneEvents(
              lane: Lane(
                name: 'Track B',
                laneIndex: 0,
              ),
              events: [
                TableEvent(

                  title: 'An event 1',
                  eventId: 1,
                  laneIndex: 1,
                  startTime: TableEventTime(hour: 10, minute: 0),
                  endTime: TableEventTime(hour: 11, minute: 20),
                ),
              ]),
          LaneEvents(
              lane: Lane(
                name: 'Track B',
                laneIndex: 0,
              ),
              events: [
                TableEvent(
                  title: 'An event 1',
                  price: '43',
                  eventId: 1,
                  laneIndex: 1,
                  startTime: TableEventTime(hour: 10, minute: 0),
                  endTime: TableEventTime(hour: 11, minute: 20),
                ),
              ]),
          LaneEvents(
              lane: Lane(
                name: 'Track B',
                laneIndex: 0,
              ),
              events: [
                TableEvent(
                  title: 'An event 1',
                  price: '433454345',
                  eventId: 1,
                  laneIndex: 1,
                  startTime: TableEventTime(hour: 10, minute: 0),
                  endTime: TableEventTime(hour: 11, minute: 20),
                ),
              ]),


        ],
        onEmptySlotTap:
            (int laneIndex, TableEventTime start, TableEventTime end) {},
        onEventTap: (TableEvent event) {},
      ),
    );
  }
}
