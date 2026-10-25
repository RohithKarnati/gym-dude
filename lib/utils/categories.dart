/// Muscle-group categories used to tag exercises and group personal records.
/// Order here is the display order (sections, dropdowns).
const List<String> workoutCategories = [
  'Chest',
  'Back',
  'Legs',
  'Shoulders',
  'Biceps',
  'Triceps',
  'Core',
  'Cardio',
  'Running',
  'Other',
];

/// Normalize a stored value to a known category, falling back to 'Other'.
String normalizeCategory(String? value) =>
    workoutCategories.contains(value) ? value! : 'Other';
