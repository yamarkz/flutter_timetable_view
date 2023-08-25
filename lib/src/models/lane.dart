import 'package:flutter/material.dart';

class Lane {
  final String name;

  /// If on a 7 week timetable this can Specify which day of the week the lane uniquely represent.
  /// Note:: if using a 7 weekday timetable Monday is 1 AND Sunday is 7 according to what is obtainable in Dart DateTime Class
  /// also number of lanes one can specify is arbitrary. you are not restricted to 7 days
  final int laneIndex;

  final double height;

  final double width;

  final Color backgroundColor;

  final TextStyle textStyle;

  Lane({
    required this.name,
    required this.laneIndex,
    this.height= 70,
    this.width= 300,
    this.backgroundColor= Colors.white,
    this.textStyle= const TextStyle(color: Colors.blue),
  });
}
