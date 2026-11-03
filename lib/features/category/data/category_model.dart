import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';

/// A single flat category row from SQLite.
@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    int? parentId,
    required DateTime createdAt,
  }) = _Category;

  const Category._();

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'] as int,
        name: map['name'] as String,
        parentId: map['parent_id'] as int?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        if (parentId != null) 'parent_id': parentId,
        'created_at': createdAt.toIso8601String(),
      };
}

/// A node in the in-memory category tree.
@freezed
class CategoryNode with _$CategoryNode {
  const factory CategoryNode({
    required Category category,
    @Default([]) List<CategoryNode> children,
  }) = _CategoryNode;
}

/// Full search result for a single matching category.
@freezed
class CategorySearchResult with _$CategorySearchResult {
  const factory CategorySearchResult({
    required Category match,
    Category? parent,
    @Default([]) List<Category> children,
    @Default([]) List<Category> path, // root → match
  }) = _CategorySearchResult;
}

/// Generic paginated result.
@freezed
class PagedResult<T> with _$PagedResult<T> {
  const factory PagedResult({
    required List<T> items,
    required int page,
    required int pageSize,
    required int totalCount,
  }) = _PagedResult<T>;
}

