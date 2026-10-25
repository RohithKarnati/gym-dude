/// Day-of-week recurrence helpers. [daysMask] uses bit 0 = Monday … bit 6 =
/// Sunday; 127 (all bits) = every day.
const int everyDayMask = 127;

const List<String> _dayAbbrev = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// Whether [weekday] (1 = Mon … 7 = Sun) is set in [daysMask].
bool isScheduledOn(int daysMask, int weekday) =>
    (daysMask & (1 << (weekday - 1))) != 0;

/// Whether the task runs today.
bool isScheduledToday(int daysMask) =>
    isScheduledOn(daysMask, DateTime.now().weekday);

/// Human label, e.g. "Every day", "Mon, Wed, Fri".
String recurrenceLabel(int daysMask) {
  final mask = daysMask & everyDayMask;
  if (mask == everyDayMask || mask == 0) return 'Every day';
  return [
    for (var w = 1; w <= 7; w++)
      if (isScheduledOn(mask, w)) _dayAbbrev[w - 1],
  ].join(', ');
}

String dayAbbrev(int weekday) => _dayAbbrev[weekday - 1];
