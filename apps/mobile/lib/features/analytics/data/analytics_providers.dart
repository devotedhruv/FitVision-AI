import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import '../domain/repositories/analytics_repository.dart';
import 'analytics_local_data_source.dart';
import 'analytics_repository_impl.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>(
  (ref) => AnalyticsRepositoryImpl(
    AnalyticsLocalDataSource(ref.watch(localDatabaseProvider)),
  ),
);
