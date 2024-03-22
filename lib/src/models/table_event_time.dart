class TableEventTime extends DateTime {
  final int hour;

  final int minute;

  TableEventTime({
    required this.hour,
    required this.minute,
  })  : assert(24 >= hour),
        assert(60 >= minute),
        super(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour,
        minute,
      );
  String toTimeString() => "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00";

  factory TableEventTime.fromTimeString(String s) {
    var parts = s.split(":");
    return TableEventTime(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
