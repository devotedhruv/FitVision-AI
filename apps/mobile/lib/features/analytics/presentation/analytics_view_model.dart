import 'package:flutter/foundation.dart';
import '../domain/models/analytics_period.dart';
import '../domain/models/progress_summary.dart';
import '../domain/repositories/analytics_repository.dart';

enum AnalyticsLoadState {
  initial,
  loading,
  data,
  empty,
  partial,
  error,
  refreshing,
}

class AnalyticsViewModel extends ChangeNotifier {
  AnalyticsViewModel(this.repository, this.userId, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final AnalyticsRepository repository;
  final String userId;
  final DateTime Function() clock;
  AnalyticsPeriodType selected = AnalyticsPeriodType.weekly;
  String? exercise;
  ProgressSummary? summary;
  AnalyticsLoadState state = AnalyticsLoadState.initial;
  String? refreshError;
  int _request = 0;
  Future<void> load({bool refresh = false}) async {
    final request = ++_request;
    state = refresh && summary != null
        ? AnalyticsLoadState.refreshing
        : AnalyticsLoadState.loading;
    refreshError = null;
    notifyListeners();
    try {
      final value = await repository.summary(
        userId,
        AnalyticsPeriod.current(
          selected,
          clock().toLocal(),
          exercise: exercise,
        ),
      );
      if (request != _request) return;
      summary = value;
      state = switch (value.completeness) {
        DataCompleteness.empty => AnalyticsLoadState.empty,
        DataCompleteness.partial => AnalyticsLoadState.partial,
        DataCompleteness.complete => AnalyticsLoadState.data,
      };
    } catch (_) {
      if (request != _request) return;
      if (summary != null) {
        refreshError = 'Analytics refresh failed. Showing saved data.';
        state = AnalyticsLoadState.partial;
      } else {
        state = AnalyticsLoadState.error;
      }
    }
    notifyListeners();
  }

  Future<void> selectPeriod(AnalyticsPeriodType value) async {
    selected = value;
    await load();
  }

  Future<void> selectExercise(String? value) async {
    exercise = value;
    await load();
  }
}
