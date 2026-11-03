import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_model.dart';
import '../../../core/providers.dart';
import '../../auth/presentation/auth_controller.dart';

// ─── Tree ────────────────────────────────────────────────────────────────────

class CategoryTreeNotifier extends AsyncNotifier<List<CategoryNode>> {
  @override
  Future<List<CategoryNode>> build() async {
    final user = ref.watch(authControllerProvider).valueOrNull;
    if (user == null) return [];
    return ref.read(categoryRepositoryProvider).getTree(user.id);
  }

  Future<void> add(String name, int? parentId) async {
    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null) return;
    final repo = ref.read(categoryRepositoryProvider);
    await repo.addCategory(name, parentId, user.id);
    ref.invalidateSelf();
    await future; // wait for rebuild
  }

  Future<void> delete(int id) async {
    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null) return;
    final repo = ref.read(categoryRepositoryProvider);
    await repo.deleteCategory(id, user.id);
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

  void collapseAll() {
    state = {};
  }

  void clear() {
    state = {};
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
  final user = ref.watch(authControllerProvider).valueOrNull;
  final query = ref.watch(searchQueryProvider);
  final page = ref.watch(searchPageProvider);
  final limit = ref.watch(searchLimitProvider);
  final repo = ref.watch(categoryRepositoryProvider);

  if (user == null || query.trim().isEmpty) {
    return PagedResult<CategorySearchResult>(
      items: [],
      page: 1,
      pageSize: 20,
      totalCount: 0,
    );
  }

  return repo.search(
    query,
    userId: user.id,
    limit: limit,
    page: page,
    pageSize: 20,
  );
});
