import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../data/category_model.dart';
import 'category_controller.dart';
import 'widgets/add_category_dialog.dart';
import 'widgets/category_tree_tile.dart';
import 'widgets/empty_state.dart';
import 'widgets/error_view.dart';
import 'widgets/search_result_card.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).update(value);
      ref.read(searchPageProvider.notifier).state = 1;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).clear();
    ref.read(searchPageProvider.notifier).state = 1;
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final isSearching = searchQuery.trim().isNotEmpty;
    final cs = Theme.of(context).colorScheme;
    final repo = ref.watch(categoryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search categories…',
              leading: const Icon(Icons.search),
              trailing: [
                if (isSearching)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _clearSearch,
                  ),
              ],
              onChanged: _onSearchChanged,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // Filter row (limit) — only in search mode
          if (isSearching) _LimitRow(),

          Expanded(
            child: isSearching
                ? _SearchResults()
                : _TreeView(repo: repo),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddCategoryDialog(
          context,
          ref,
          repo: repo,
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
      ),
    );
  }
}

// ─── Filter row ──────────────────────────────────────────────────────────────

class _LimitRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limit = ref.watch(searchLimitProvider);
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        children: [
          Text(
            'Limit:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 8),
          ...([null, 10, 20, 50].map((v) {
            final selected = limit == v;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(v == null ? 'None' : '$v'),
                selected: selected,
                onSelected: (_) {
                  ref.read(searchLimitProvider.notifier).state = v;
                  ref.read(searchPageProvider.notifier).state = 1;
                },
                visualDensity: VisualDensity.compact,
              ),
            );
          })),
        ],
      ),
    );
  }
}

// ─── Tree view ───────────────────────────────────────────────────────────────

class _TreeView extends ConsumerWidget {
  const _TreeView({required this.repo});

  final dynamic repo; // CategoryRepository

  int _countTotal(List<CategoryNode> nodes) {
    int count = 0;
    for (final node in nodes) {
      count += 1 + _countTotal(node.children);
    }
    return count;
  }

  Set<int> _collectParentIds(List<CategoryNode> nodes) {
    final ids = <int>{};
    for (final node in nodes) {
      if (node.children.isNotEmpty) {
        ids.add(node.category.id);
        ids.addAll(_collectParentIds(node.children));
      }
    }
    return ids;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeState = ref.watch(categoryTreeProvider);
    final expandedIds = ref.watch(expandedIdsProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return treeState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(categoryTreeProvider),
      ),
      data: (roots) {
        if (roots.isEmpty) {
          return const EmptyState(
            icon: Icons.account_tree_outlined,
            title: 'No categories yet',
            subtitle: 'Tap "+ Add Category" below to create your first root category.',
          );
        }

        final totalCount = _countTotal(roots);
        final parentIds = _collectParentIds(roots);
        final allExpanded = parentIds.isNotEmpty && parentIds.every(expandedIds.contains);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          children: [
            // Tree controls header
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Row(
                children: [
                  Text(
                    '$totalCount ${totalCount == 1 ? 'category' : 'categories'}',
                    style: tt.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (parentIds.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        if (allExpanded) {
                          ref.read(expandedIdsProvider.notifier).collapseAll();
                        } else {
                          ref.read(expandedIdsProvider.notifier).expandAll(parentIds);
                        }
                      },
                      icon: Icon(
                        allExpanded
                            ? Icons.unfold_less_rounded
                            : Icons.unfold_more_rounded,
                        size: 16,
                      ),
                      label: Text(allExpanded ? 'Collapse all' : 'Expand all'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: cs.primary,
                      ),
                    ),
                ],
              ),
            ),

            // Root tiles
            for (final root in roots)
              CategoryTreeTile(
                node: root,
                depth: 0,
                repo: repo,
              ),
          ],
        );
      },
    );
  }
}

// ─── Search results ──────────────────────────────────────────────────────────

class _SearchResults extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return searchState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(searchResultsProvider),
      ),
      data: (paged) {
        if (paged.items.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
            title: 'No results for "$query"',
            subtitle: 'Try a different search term.',
          );
        }

        final page = paged.page;
        final pageSize = paged.pageSize;
        final total = paged.totalCount;
        final totalPages = (total / pageSize).ceil().clamp(1, double.infinity).toInt();

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                itemCount: paged.items.length,
                itemBuilder: (_, i) =>
                    SearchResultCard(result: paged.items[i]),
              ),
            ),

            // Pagination footer
            Container(
              color: cs.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  Text(
                    'Page $page · Page size $pageSize · Total $total',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: page > 1
                            ? () => ref
                                .read(searchPageProvider.notifier)
                                .state = page - 1
                            : null,
                        icon: const Icon(Icons.chevron_left, size: 18),
                        label: const Text('Prev'),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$page / $totalPages',
                        style: tt.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: page < totalPages
                            ? () => ref
                                .read(searchPageProvider.notifier)
                                .state = page + 1
                            : null,
                        icon: const Icon(Icons.chevron_right, size: 18),
                        label: const Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
