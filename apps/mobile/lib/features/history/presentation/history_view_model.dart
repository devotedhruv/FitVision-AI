import 'package:flutter/foundation.dart';
import '../domain/models/history_filter.dart';
import '../domain/models/history_item.dart';
import '../domain/repositories/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel(this.repository, this.userId);
  final HistoryRepository repository;
  final String userId;
  HistoryFilter filter = const HistoryFilter();
  List<HistoryItem> items = const [];
  bool loading = false, hasMore = true;
  String? error;
  int _page = 0;
  Future<void> load({bool reset = true}) async {
    if (loading) return;
    loading = true;
    error = null;
    if (reset) {
      _page = 0;
      items = const [];
      hasMore = true;
    }
    notifyListeners();
    try {
      final next = await repository.page(userId, filter, page: _page);
      items = List.unmodifiable([
        ...items,
        ...next.where(
          (n) => !items.any(
            (i) => i.localId == n.localId && i.category == n.category,
          ),
        ),
      ]);
      hasMore = next.length == filter.pageSize;
      if (hasMore) _page++;
    } catch (_) {
      error = 'Local history could not be loaded.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> apply(HistoryFilter value) async {
    filter = value;
    await load();
  }
}
