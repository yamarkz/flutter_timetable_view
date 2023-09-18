import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';


class Utils {
  static bool sameDay(DateTime date, [DateTime? target]) {
    target = target ?? DateTime.now();
    return target.year == date.year &&
        target.month == date.month &&
        target.day == date.day;
  }

  static String removeLastWord(String string) {
    List<String> words = string.split(' ');
    if (words.isEmpty) {
      return '';
    }

    return words.getRange(0, words.length - 1).join(' ');
  }

  static String dateFormatter(int year, int month, int day) {
    return year.toString() +
        '-' +
        _addLeadingZero(month) +
        '-' +
        _addLeadingZero(day);
  }

  static String formatHourInto24Hours(int hour, int minute) {
    return _addLeadingZero(hour) + ':' + _addLeadingZero(minute);
  }

  static String hourFormatter(int hour, int minute, bool showAsAMPM) {
    if (showAsAMPM) {
      return formatHourIntoAmPM(hour, minute);
    } else {
      return formatHourInto24Hours(hour, minute);
    }
  }

  static String formatHourIntoAmPM(int hour, int minute) {
    String formattedString = '';

    // convert 0 Am to 12 Am
    if (hour == 0) {
      formattedString = "12";
    } else {
      formattedString = hour > 12 ? (hour - 12).toString() : hour.toString();
    }

    // if minute is 0, just display time as 12 Am, or 2 PM
    if (minute > 0) {
      formattedString += ":" + _addLeadingZero(minute);
    }

    formattedString += " ${hour >= 12 ? "PM" : "AM"}";

    return formattedString;
  }

  static Widget eventText(
      TableEvent event,
      BuildContext context,
      double height,
      double width,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // aligns text to the left
      children: [
        Text(
          event.title,
          style: TextStyle(fontWeight: event.titleTextStyle.fontWeight,fontSize: event.titleTextStyle.fontSize,color: event.titleTextStyle.color),
        ),
        SizedBox(height: 5,),
        Text(
          event.price,
          style: TextStyle(fontWeight: event.priceTextStyle.fontWeight,fontSize: event.priceTextStyle.fontSize,color: event.priceTextStyle.color),
        ),
      ],
    );
  }

  static String _addLeadingZero(int number) {
    return (number < 10 ? '0' : '') + number.toString();
  }

  static bool? _exceedHeight(
      List<TextSpan> input, TextStyle textStyle, double height, double width) {
    double fontSize = textStyle.fontSize ?? 14;
    int maxLines = height ~/ ((textStyle.height ?? 1.2) * fontSize);
    if (maxLines == 0) {
      return null;
    }

    TextPainter painter = TextPainter(
      text: TextSpan(
        children: input,
        style: textStyle,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: width);
    return painter.didExceedMaxLines;
  }

  static bool _ellipsize(List<TextSpan> input, [String ellipse = '…']) {
    if (input.isEmpty) {
      return false;
    }

    TextSpan last = input.last;
    String text = last.text!;
    if (text.isEmpty || text == ellipse) {
      input.removeLast();

      if (text == ellipse) {
        _ellipsize(input, ellipse);
      }
      return true;
    }

    String truncatedText;
    if (text.endsWith('\n')) {
      truncatedText = text.substring(0, text.length - 1) + ellipse;
    } else {
      truncatedText = Utils.removeLastWord(text);
      truncatedText =
          truncatedText.substring(0, math.max(0, truncatedText.length - 2)) +
              ellipse;
    }

    input[input.length - 1] = TextSpan(
      text: truncatedText,
      style: last.style,
    );

    return true;
  }
}

