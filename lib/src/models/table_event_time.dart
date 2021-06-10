class TableEventTime extends DateTime {
  final int hour;

  final int minute;

  TableEventTime({
    required this.hour,
    required this.minute,
  })  : 
        assert(24 >= hour),
       
        assert(60 >= minute),
        super(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          hour,
          minute,
        );
}
