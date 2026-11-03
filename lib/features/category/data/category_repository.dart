import 'package:sqflite/sqflite.dart';

import '../../../core/error/app_exception.dart';
import 'category_model.dart';

class CategoryRepository {
  CategoryRepository({required Database database}) : _db = database;

  final Database _db;

  // ─────────────────────────────────────────────
  // Tree
  // ─────────────────────────────────────────────

  /// Fetches all rows once and builds the tree in O(n).
  Future<List<CategoryNode>> getTree() async {
    final rows = await _db.query('categories', orderBy: 'name ASC');
    final categories = rows.map(Category.fromMap).toList();
    return _buildTree(categories);
  }

  static List<CategoryNode> _buildTree(List<Category> all) {
    final byParent = <int?, List<Category>>{};
    for (final c in all) {
      byParent.putIfAbsent(c.parentId, () => []).add(c);
    }
    return _buildNodes(null, byParent);
  }

  static List<CategoryNode> _buildNodes(
    int? parentId,
    Map<int?, List<Category>> byParent,
  ) {
    final children = byParent[parentId] ?? [];
    return children
        .map(
          (c) => CategoryNode(
            category: c,
            children: _buildNodes(c.id, byParent),
          ),
        )
        .toList();
  }

  // ─── Test helpers (pure functions exposed for unit tests) ─────────────────

  /// Exposed for unit tests — same logic as [_buildTree].
  static List<CategoryNode> buildTreeForTest(List<Category> all) =>
      _buildTree(all);

  /// Exposed for unit tests — same logic as [_buildPath].
  static List<Category> buildPathForTest(
    int id,
    Map<int, Category> byId,
  ) =>
      _buildPath(id, byId);

  // ─────────────────────────────────────────────
  // Mutations
  // ─────────────────────────────────────────────

  /// Validates, checks duplicates, and inserts a new category.
  Future<Category> addCategory(String name, int? parentId) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const AppException('Name cannot be empty.');
    }
    if (trimmed.length > 50) {
      throw const AppException('Name must be 50 characters or less.');
    }

    // Duplicate check: same trimmed name (case-insensitive) under same parent.
    final existing = await _db.query(
      'categories',
      where: 'LOWER(name) = LOWER(?) AND parent_id IS ?',
      whereArgs: [trimmed, parentId],
    );
    if (existing.isNotEmpty) {
      throw AppException('"$trimmed" already exists here.');
    }

    final now = DateTime.now().toIso8601String();
    final category = Category(
      id: 0, // placeholder; overwritten by autoincrement
      name: trimmed,
      parentId: parentId,
      createdAt: DateTime.now(),
    );

    final id = await _db.insert('categories', {
      'name': trimmed,
      'parent_id': parentId,
      'created_at': now,
    });

    return category.copyWith(id: id);
  }

  /// Deletes a category (and its entire subtree via CASCADE).
  Future<void> deleteCategory(int id) async {
    await _db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────────
  // Search
  // ─────────────────────────────────────────────

  /// Searches by name substring, returns paginated results with full context.
  Future<PagedResult<CategorySearchResult>> search(
    String query, {
    int? limit,
    int page = 1,
    int pageSize = 20,
  }) async {
    final q = query.trim().toLowerCase();

    // Count matches
    final countResult = await _db.rawQuery(
      "SELECT COUNT(*) AS cnt FROM categories WHERE LOWER(name) LIKE ?",
      ['%$q%'],
    );
    int totalCount = (countResult.first['cnt'] as int?) ?? 0;

    // Apply limit cap
    if (limit != null && limit < totalCount) {
      totalCount = limit;
    }

    final effectivePage = page < 1 ? 1 : page;
    final offset = (effectivePage - 1) * pageSize;

    // Clamp page size so we never exceed the limit
    final effectivePageSize = (limit != null)
        ? pageSize.clamp(0, (totalCount - offset).clamp(0, pageSize))
        : pageSize;

    // Fetch this page of matches
    final rows = await _db.rawQuery(
      "SELECT * FROM categories WHERE LOWER(name) LIKE ? ORDER BY name ASC LIMIT ? OFFSET ?",
      ['%$q%', effectivePageSize, offset],
    );

    final matches = rows.map(Category.fromMap).toList();

    // Fetch all rows for building context (parent, children, path)
    final allRows = await _db.query('categories');
    final all = allRows.map(Category.fromMap).toList();
    final byId = {for (final c in all) c.id: c};
    final byParent = <int?, List<Category>>{};
    for (final c in all) {
      byParent.putIfAbsent(c.parentId, () => []).add(c);
    }

    final results = matches.map((match) {
      final parent = match.parentId != null ? byId[match.parentId] : null;
      final children = byParent[match.id] ?? [];
      final path = _buildPath(match.id, byId);
      return CategorySearchResult(
        match: match,
        parent: parent,
        children: children,
        path: path,
      );
    }).toList();

    return PagedResult<CategorySearchResult>(
      items: results,
      page: effectivePage,
      pageSize: pageSize,
      totalCount: totalCount,
    );
  }

  /// Builds path from root → [id] using iterative parent lookup.
  static List<Category> _buildPath(
    int id,
    Map<int, Category> byId,
  ) {
    final path = <Category>[];
    Category? current = byId[id];
    while (current != null) {
      path.insert(0, current);
      current = current.parentId != null ? byId[current.parentId!] : null;
    }
    return path;
  }

  /// Gets the path from root to [id] using a recursive CTE.
  Future<List<Category>> getPath(int id) async {
    final rows = await _db.rawQuery('''
      WITH RECURSIVE ancestors(id, name, parent_id, created_at, depth) AS (
        SELECT id, name, parent_id, created_at, 0
        FROM categories WHERE id = ?
        UNION ALL
        SELECT c.id, c.name, c.parent_id, c.created_at, a.depth + 1
        FROM categories c
        JOIN ancestors a ON c.id = a.parent_id
      )
      SELECT id, name, parent_id, created_at FROM ancestors
      ORDER BY depth DESC
    ''', [id]);

    return rows.map(Category.fromMap).toList();
  }
}
