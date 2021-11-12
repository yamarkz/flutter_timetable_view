import 'package:flutter/material.dart';

class Lane {
  final String name;

  final double height;

  final double width;

  final Color backgroundColor;

  final TextStyle textStyle;

  Lane({
    required this.name,
    this.height: 70,
    this.width: 300,
    this.backgroundColor: Colors.white,
    this.textStyle: const TextStyle(color: Colors.blue),
  });
}
