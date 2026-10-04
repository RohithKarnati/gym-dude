/// Weekday helpers. 1 = Monday .. 7 = Sunday (matches Dart's DateTime.weekday).
const List<String> kWeekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> kWeekdayShort = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

String weekdayName(int weekday) => kWeekdayNames[(weekday - 1) % 7];

String weekdayShort(int weekday) => kWeekdayShort[(weekday - 1) % 7];

int todayWeekday() => DateTime.now().weekday;
