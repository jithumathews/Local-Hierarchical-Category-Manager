import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_model.dart';
import '../../../core/providers.dart';

// ─── Tree ────────────────────────────────────────────────────────────────────

class CategoryTreeNotifier extends AsyncNotifier<List<CategoryNode>> {
  @override
  Future<List<CategoryNode>> build() async {
    return ref.read(categoryRepositoryProvider).getTree();
  }

  Future<void> add(String name, int? parentId) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.addCategory(name, parentId);
    ref.invalidateSelf();
    await future; // wait for rebuild
  }

  Future<void> delete(int id) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.deleteCategory(id);
    ref.invalidateSelf();
    await future;
  }
}

final categoryTreeProvider =
    AsyncNotifierProvider<CategoryTreeNotifier, List<CategoryNode>>(
  CategoryTreeNotifier.new,
);

// ─── Expanded node IDs ───────────────────────────────────────────────────────

class ExpandedIdsNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  void toggle(int id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void collapse(int id) {
    state = {...state}..remove(id);
  }

  void expandAll(Iterable<int> ids) {
    state = {...state, ...ids};
  }
}

final expandedIdsProvider =
    NotifierProvider<ExpandedIdsNotifier, Set<int>>(ExpandedIdsNotifier.new);

// ─── Search ──────────────────────────────────────────────────────────────────

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
  void clear() => state = '';
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final searchPageProvider = StateProvider<int>((ref) => 1);
final searchLimitProvider = StateProvider<int?>((ref) => null);

final searchResultsProvider =
    FutureProvider<PagedResult<CategorySearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final page = ref.watch(searchPageProvider);
  final limit = ref.watch(searchLimitProvider);
  final repo = ref.watch(categoryRepositoryProvider);

  if (query.trim().isEmpty) {
    return PagedResult<CategorySearchResult>(
      items: [],
      page: 1,
      pageSize: 20,
      totalCount: 0,
    );
  }

  return repo.search(query, limit: limit, page: page, pageSize: 20);
});
