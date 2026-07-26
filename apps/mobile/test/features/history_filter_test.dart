import 'package:fitvision_ai/features/history/domain/models/history_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('today uses inclusive local start and exclusive next-day end', () {
    final range = const HistoryFilter(
      datePreset: HistoryDatePreset.today,
    ).utcRange(DateTime(2026, 1, 2, 15));
    expect(range.startUtc!.toLocal(), DateTime(2026, 1, 2));
    expect(range.endUtc!.toLocal(), DateTime(2026, 1, 3));
  });
  test('last seven days includes seven local calendar dates', () {
    final range = const HistoryFilter(
      datePreset: HistoryDatePreset.last7Days,
    ).utcRange(DateTime(2026, 1, 10, 20));
    expect(range.endUtc!.difference(range.startUtc!), const Duration(days: 7));
  });
  test(
    'invalid custom range is rejected',
    () => expect(
      () => HistoryFilter(
        datePreset: HistoryDatePreset.custom,
        customStart: DateTime(2026, 2),
        customEnd: DateTime(2026, 1),
      ).utcRange(DateTime(2026)),
      throwsArgumentError,
    ),
  );
  test('filters remain combinable and default page is bounded', () {
    const value = HistoryFilter(
      category: HistoryCategoryFilter.exercise,
      exercise: HistoryExerciseFilter.squat,
      sync: HistorySyncFilter.pending,
    );
    expect(value.pageSize, 25);
    expect(value.category, HistoryCategoryFilter.exercise);
  });
}
