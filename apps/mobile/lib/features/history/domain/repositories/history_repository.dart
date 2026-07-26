import '../models/history_filter.dart';
import '../models/history_item.dart';
import '../models/session_detail.dart';

abstract interface class HistoryRepository {
  Future<List<HistoryItem>> page(
    String userId,
    HistoryFilter filter, {
    int page = 0,
  });
  Stream<void> changes(String userId);
  Future<SessionDetail?> detail(
    String userId,
    String localId,
    HistoryCategory category,
  );
}
