
import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event_time.dart';


class TableEvent {
  final String title;

  /// Id to uniquely identify event. Used mainly in callbacks
  final int eventId;

  /// Id to uniquely identify the lane an event falls under. Used mainly in callbacks
  final int laneIndex;

  /// Optional. Preferably abbreviate string to less than 5 characters
  final String price;

  final TableEventTime startTime;

  final TableEventTime endTime;

  final EdgeInsets padding;

  final EdgeInsets margin;


  // //Todo:: Determine if Event ID needs to be passed to callback
  // final void Function(
  //         int laneIndex, String title, TableEventTime start, TableEventTime end)
  //     onTap;

  final BoxDecoration? decoration;

  final Color backgroundColor;

  final TextStyle textStyle;
  final TextStyle titleTextStyle;
  final TextStyle priceTextStyle;


  TableEvent({
    this.titleTextStyle=const TextStyle(color: Colors.white),
    this.priceTextStyle= const TextStyle(color: Colors.white),
    required this.title,
    required this.eventId,
    required this.laneIndex,
    this.price= '',
    required this.startTime,
    required this.endTime,
    this.padding= const EdgeInsets.all(10),
    this.margin= const EdgeInsets.all(1),
    // this.onTap,
    this.decoration,
    this.backgroundColor= const Color(0xCC2196F3),
    this.textStyle= const TextStyle(color: Colors.white),
  }) : assert(endTime.isAfter(startTime));
  @override
  List<Object?> get props => [
    title,
    eventId,
    laneIndex,
    price,
    startTime,
    endTime,
    padding,
    margin,
    decoration,
    backgroundColor,
    textStyle,
  ];
}


