import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_dao.dart';
import '../data/database.dart';
import '../utils/categories.dart';
import 'database_provider.dart';

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  return CategoryDao(ref.watch(databaseProvider));
});

/// User-defined categories (reactive).
final customCategoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryDaoProvider).watchCustom();
});

/// Full category list for pickers: built-in presets with custom ones inserted
/// just before the trailing "Other".
final allCategoriesProvider = Provider<List<String>>((ref) {
  final custom = ref.watch(customCategoriesProvider).value ?? const [];
  final customNames =
      custom.map((c) => c.name).where((n) => !workoutCategories.contains(n));
  final presets = [...workoutCategories];
  final otherIndex = presets.indexOf('Other');
  final insertAt = otherIndex >= 0 ? otherIndex : presets.length;
  return [
    ...presets.sublist(0, insertAt),
    ...customNames,
    ...presets.sublist(insertAt),
  ];
});
