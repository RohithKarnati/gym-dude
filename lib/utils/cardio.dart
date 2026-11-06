/// Helpers for cardio exercises (distance / duration / count) vs. classic
/// strength logging (weight × reps). A null metric means strength.
library;

/// The selectable cardio metrics, in menu order.
const List<String> cardioMetrics = ['distance', 'duration', 'count'];

/// Short label for a metric (null = strength).
String metricLabel(String? metric) {
  switch (metric) {
    case 'distance':
      return 'Distance (km)';
    case 'duration':
      return 'Duration (min)';
    case 'count':
      return 'Count (reps)';
    default:
      return 'Weight & reps';
  }
}

/// The unit shown next to the primary input/value.
String metricUnit(String? metric) {
  switch (metric) {
    case 'distance':
      return 'km';
    case 'duration':
      return 'min';
    case 'count':
      return 'reps';
    default:
      return 'kg';
  }
}

String _fmtNum(num v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

/// mm:ss from whole seconds.
String fmtDuration(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// A human summary of a logged cardio effort for a given metric.
/// [distanceKm]/[durationSec]/[count] are read as the metric needs.
String cardioSummary(
  String metric, {
  double? distanceKm,
  int? durationSec,
  int? count,
}) {
  switch (metric) {
    case 'distance':
      final d = distanceKm ?? 0;
      final base = '${_fmtNum(d)} km';
      if (durationSec != null && durationSec > 0) {
        return '$base in ${fmtDuration(durationSec)}';
      }
      return base;
    case 'duration':
      final secs = durationSec ?? 0;
      return secs >= 60 ? '${secs ~/ 60} min' : '${secs}s';
    case 'count':
      return '${count ?? 0} reps';
    default:
      return '';
  }
}
