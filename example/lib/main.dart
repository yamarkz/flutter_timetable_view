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


Widget buildConfirmationBar(VoidCallback clearSelected) {
  return     Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: BoxDecoration(
      color: Colors.blue, // Change to your preferred color
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('نهایی کردن انتخاب'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap:()=> clearSelected(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.red,
                child: Text('انصراف', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.green,
              child: Text('تاكيد', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    ),
  );
}
bool showLongPressMessage = false;
List<TableEventTime>? selectedItems;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void clearSelectedItems() {
    print("selectedItems before  "+selectedItems.toString());
    setState(() {
      selectedItems?.clear();
    });
    print("selectedItems after clean "+selectedItems.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showLongPressMessage ? buildConfirmationBar(clearSelectedItems) : SizedBox(),
      appBar: AppBar(),
      body: TimetableView(
        isMultiSelectEnabled: false,
        selectedItems: (List<TableEventTime>? selectedList) {
          setState(() {
            selectedItems = selectedList;
          });
        },
        onLongPressStateChanged: (isLongPressed) {
          showLongPressMessage=isLongPressed;
          setState(() {

          });
          print('onLongPressStateChanged');
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
            (int laneIndex, TableEventTime start, TableEventTime end) {


            },
        onEventTap: (TableEvent event) {},
      ),
    );
  }
}
