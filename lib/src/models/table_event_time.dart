class TableEventTime extends DateTime {
  final int hour;

  final int minute;

  TableEventTime({
    this.hour,
    this.minute,
  })  : assert(hour != null),
        assert(24 >= hour),
        assert(minute != null),
        assert(60 >= minute),
        super(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          hour,
          minute,
        );
}
