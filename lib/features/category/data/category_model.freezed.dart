// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Category {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get parentId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({
    int id,
    int userId,
    String name,
    int? parentId,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
    _$CategoryImpl value,
    $Res Function(_$CategoryImpl) then,
  ) = __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int userId,
    String name,
    int? parentId,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
    _$CategoryImpl _value,
    $Res Function(_$CategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$CategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$CategoryImpl extends _Category {
  const _$CategoryImpl({
    required this.id,
    required this.userId,
    required this.name,
    this.parentId,
    required this.createdAt,
  }) : super._();

  @override
  final int id;
  @override
  final int userId;
  @override
  final String name;
  @override
  final int? parentId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Category(id: $id, userId: $userId, name: $name, parentId: $parentId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, name, parentId, createdAt);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);
}

abstract class _Category extends Category {
  const factory _Category({
    required final int id,
    required final int userId,
    required final String name,
    final int? parentId,
    required final DateTime createdAt,
  }) = _$CategoryImpl;
  const _Category._() : super._();

  @override
  int get id;
  @override
  int get userId;
  @override
  String get name;
  @override
  int? get parentId;
  @override
  DateTime get createdAt;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CategoryNode {
  Category get category => throw _privateConstructorUsedError;
  List<CategoryNode> get children => throw _privateConstructorUsedError;

  /// Create a copy of CategoryNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryNodeCopyWith<CategoryNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryNodeCopyWith<$Res> {
  factory $CategoryNodeCopyWith(
    CategoryNode value,
    $Res Function(CategoryNode) then,
  ) = _$CategoryNodeCopyWithImpl<$Res, CategoryNode>;
  @useResult
  $Res call({Category category, List<CategoryNode> children});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$CategoryNodeCopyWithImpl<$Res, $Val extends CategoryNode>
    implements $CategoryNodeCopyWith<$Res> {
  _$CategoryNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? children = null}) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as Category,
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<CategoryNode>,
          )
          as $Val,
    );
  }

  /// Create a copy of CategoryNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryNodeImplCopyWith<$Res>
    implements $CategoryNodeCopyWith<$Res> {
  factory _$$CategoryNodeImplCopyWith(
    _$CategoryNodeImpl value,
    $Res Function(_$CategoryNodeImpl) then,
  ) = __$$CategoryNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Category category, List<CategoryNode> children});

  @override
  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$CategoryNodeImplCopyWithImpl<$Res>
    extends _$CategoryNodeCopyWithImpl<$Res, _$CategoryNodeImpl>
    implements _$$CategoryNodeImplCopyWith<$Res> {
  __$$CategoryNodeImplCopyWithImpl(
    _$CategoryNodeImpl _value,
    $Res Function(_$CategoryNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? children = null}) {
    return _then(
      _$CategoryNodeImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as Category,
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<CategoryNode>,
      ),
    );
  }
}

/// @nodoc

class _$CategoryNodeImpl implements _CategoryNode {
  const _$CategoryNodeImpl({
    required this.category,
    final List<CategoryNode> children = const [],
  }) : _children = children;

  @override
  final Category category;
  final List<CategoryNode> _children;
  @override
  @JsonKey()
  List<CategoryNode> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'CategoryNode(category: $category, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryNodeImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    const DeepCollectionEquality().hash(_children),
  );

  /// Create a copy of CategoryNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryNodeImplCopyWith<_$CategoryNodeImpl> get copyWith =>
      __$$CategoryNodeImplCopyWithImpl<_$CategoryNodeImpl>(this, _$identity);
}

abstract class _CategoryNode implements CategoryNode {
  const factory _CategoryNode({
    required final Category category,
    final List<CategoryNode> children,
  }) = _$CategoryNodeImpl;

  @override
  Category get category;
  @override
  List<CategoryNode> get children;

  /// Create a copy of CategoryNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryNodeImplCopyWith<_$CategoryNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CategorySearchResult {
  Category get match => throw _privateConstructorUsedError;
  Category? get parent => throw _privateConstructorUsedError;
  List<Category> get children => throw _privateConstructorUsedError;
  List<Category> get path => throw _privateConstructorUsedError;

  /// Create a copy of CategorySearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySearchResultCopyWith<CategorySearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySearchResultCopyWith<$Res> {
  factory $CategorySearchResultCopyWith(
    CategorySearchResult value,
    $Res Function(CategorySearchResult) then,
  ) = _$CategorySearchResultCopyWithImpl<$Res, CategorySearchResult>;
  @useResult
  $Res call({
    Category match,
    Category? parent,
    List<Category> children,
    List<Category> path,
  });

  $CategoryCopyWith<$Res> get match;
  $CategoryCopyWith<$Res>? get parent;
}

/// @nodoc
class _$CategorySearchResultCopyWithImpl<
  $Res,
  $Val extends CategorySearchResult
>
    implements $CategorySearchResultCopyWith<$Res> {
  _$CategorySearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? match = null,
    Object? parent = freezed,
    Object? children = null,
    Object? path = null,
  }) {
    return _then(
      _value.copyWith(
            match: null == match
                ? _value.match
                : match // ignore: cast_nullable_to_non_nullable
                      as Category,
            parent: freezed == parent
                ? _value.parent
                : parent // ignore: cast_nullable_to_non_nullable
                      as Category?,
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<Category>,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as List<Category>,
          )
          as $Val,
    );
  }

  /// Create a copy of CategorySearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get match {
    return $CategoryCopyWith<$Res>(_value.match, (value) {
      return _then(_value.copyWith(match: value) as $Val);
    });
  }

  /// Create a copy of CategorySearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get parent {
    if (_value.parent == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.parent!, (value) {
      return _then(_value.copyWith(parent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategorySearchResultImplCopyWith<$Res>
    implements $CategorySearchResultCopyWith<$Res> {
  factory _$$CategorySearchResultImplCopyWith(
    _$CategorySearchResultImpl value,
    $Res Function(_$CategorySearchResultImpl) then,
  ) = __$$CategorySearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Category match,
    Category? parent,
    List<Category> children,
    List<Category> path,
  });

  @override
  $CategoryCopyWith<$Res> get match;
  @override
  $CategoryCopyWith<$Res>? get parent;
}

/// @nodoc
class __$$CategorySearchResultImplCopyWithImpl<$Res>
    extends _$CategorySearchResultCopyWithImpl<$Res, _$CategorySearchResultImpl>
    implements _$$CategorySearchResultImplCopyWith<$Res> {
  __$$CategorySearchResultImplCopyWithImpl(
    _$CategorySearchResultImpl _value,
    $Res Function(_$CategorySearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategorySearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? match = null,
    Object? parent = freezed,
    Object? children = null,
    Object? path = null,
  }) {
    return _then(
      _$CategorySearchResultImpl(
        match: null == match
            ? _value.match
            : match // ignore: cast_nullable_to_non_nullable
                  as Category,
        parent: freezed == parent
            ? _value.parent
            : parent // ignore: cast_nullable_to_non_nullable
                  as Category?,
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<Category>,
        path: null == path
            ? _value._path
            : path // ignore: cast_nullable_to_non_nullable
                  as List<Category>,
      ),
    );
  }
}

/// @nodoc

class _$CategorySearchResultImpl implements _CategorySearchResult {
  const _$CategorySearchResultImpl({
    required this.match,
    this.parent,
    final List<Category> children = const [],
    final List<Category> path = const [],
  }) : _children = children,
       _path = path;

  @override
  final Category match;
  @override
  final Category? parent;
  final List<Category> _children;
  @override
  @JsonKey()
  List<Category> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  final List<Category> _path;
  @override
  @JsonKey()
  List<Category> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  String toString() {
    return 'CategorySearchResult(match: $match, parent: $parent, children: $children, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySearchResultImpl &&
            (identical(other.match, match) || other.match == match) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            const DeepCollectionEquality().equals(other._path, _path));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    match,
    parent,
    const DeepCollectionEquality().hash(_children),
    const DeepCollectionEquality().hash(_path),
  );

  /// Create a copy of CategorySearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySearchResultImplCopyWith<_$CategorySearchResultImpl>
  get copyWith =>
      __$$CategorySearchResultImplCopyWithImpl<_$CategorySearchResultImpl>(
        this,
        _$identity,
      );
}

abstract class _CategorySearchResult implements CategorySearchResult {
  const factory _CategorySearchResult({
    required final Category match,
    final Category? parent,
    final List<Category> children,
    final List<Category> path,
  }) = _$CategorySearchResultImpl;

  @override
  Category get match;
  @override
  Category? get parent;
  @override
  List<Category> get children;
  @override
  List<Category> get path;

  /// Create a copy of CategorySearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySearchResultImplCopyWith<_$CategorySearchResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PagedResult<T> {
  List<T> get items => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;

  /// Create a copy of PagedResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PagedResultCopyWith<T, PagedResult<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedResultCopyWith<T, $Res> {
  factory $PagedResultCopyWith(
    PagedResult<T> value,
    $Res Function(PagedResult<T>) then,
  ) = _$PagedResultCopyWithImpl<T, $Res, PagedResult<T>>;
  @useResult
  $Res call({List<T> items, int page, int pageSize, int totalCount});
}

/// @nodoc
class _$PagedResultCopyWithImpl<T, $Res, $Val extends PagedResult<T>>
    implements $PagedResultCopyWith<T, $Res> {
  _$PagedResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PagedResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? pageSize = null,
    Object? totalCount = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<T>,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PagedResultImplCopyWith<T, $Res>
    implements $PagedResultCopyWith<T, $Res> {
  factory _$$PagedResultImplCopyWith(
    _$PagedResultImpl<T> value,
    $Res Function(_$PagedResultImpl<T>) then,
  ) = __$$PagedResultImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, int page, int pageSize, int totalCount});
}

/// @nodoc
class __$$PagedResultImplCopyWithImpl<T, $Res>
    extends _$PagedResultCopyWithImpl<T, $Res, _$PagedResultImpl<T>>
    implements _$$PagedResultImplCopyWith<T, $Res> {
  __$$PagedResultImplCopyWithImpl(
    _$PagedResultImpl<T> _value,
    $Res Function(_$PagedResultImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of PagedResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? pageSize = null,
    Object? totalCount = null,
  }) {
    return _then(
      _$PagedResultImpl<T>(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<T>,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$PagedResultImpl<T> implements _PagedResult<T> {
  const _$PagedResultImpl({
    required final List<T> items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  }) : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int page;
  @override
  final int pageSize;
  @override
  final int totalCount;

  @override
  String toString() {
    return 'PagedResult<$T>(items: $items, page: $page, pageSize: $pageSize, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagedResultImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    page,
    pageSize,
    totalCount,
  );

  /// Create a copy of PagedResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PagedResultImplCopyWith<T, _$PagedResultImpl<T>> get copyWith =>
      __$$PagedResultImplCopyWithImpl<T, _$PagedResultImpl<T>>(
        this,
        _$identity,
      );
}

abstract class _PagedResult<T> implements PagedResult<T> {
  const factory _PagedResult({
    required final List<T> items,
    required final int page,
    required final int pageSize,
    required final int totalCount,
  }) = _$PagedResultImpl<T>;

  @override
  List<T> get items;
  @override
  int get page;
  @override
  int get pageSize;
  @override
  int get totalCount;

  /// Create a copy of PagedResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PagedResultImplCopyWith<T, _$PagedResultImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
