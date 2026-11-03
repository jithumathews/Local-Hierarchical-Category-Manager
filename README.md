# Scholigence — Local Hierarchical Category Manager

A Flutter app with mock login via JSONPlaceholder, a profile screen, and an unlimited-depth category tree stored locally in SQLite.

---

## Setup & Run

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate freezed / json_serializable code
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

---

## Architecture

```
Presentation → Repository → Data source
```

A simple 3-layer architecture with no use-case classes:

| Layer | Responsibility |
|---|---|
| **Presentation** | Flutter widgets + Riverpod controllers (`AsyncNotifier`/`Notifier`) |
| **Repository** | All business logic, SQL queries, validation, tree & path building |
| **Data source** | `Dio` (HTTP) and `sqflite` (SQLite) — never touched by the UI |

```
lib/
  main.dart                    ← ProviderScope entry point
  app.dart                     ← MaterialApp, theme, root router
  core/
    theme/app_theme.dart       ← Material 3 light/dark themes (Poppins font)
    error/app_exception.dart   ← User-friendly exception type
    db/database_helper.dart    ← SQLite open/create, foreign keys, indexes
    providers.dart             ← Dio, DB, SharedPreferences, repositories
  features/
    auth/
      data/user_model.dart         ← freezed + json_serializable User & Company
      data/auth_repository.dart    ← JSONPlaceholder fetch + SharedPreferences
      presentation/auth_controller.dart
      presentation/login_screen.dart
      presentation/profile_screen.dart
    category/
      data/category_model.dart          ← Category, CategoryNode, PagedResult
      data/category_repository.dart     ← All SQL + tree/path logic
      presentation/category_controller.dart
      presentation/category_screen.dart
      presentation/widgets/
        category_tree_tile.dart
        search_result_card.dart
        add_category_dialog.dart
        empty_state.dart
        error_view.dart
```

---

## Tech Stack

| Concern | Choice |
|---|---|
| State management | `flutter_riverpod` — `Notifier` / `AsyncNotifier`, no codegen for providers |
| Models | `freezed` + `json_serializable` |
| HTTP | `dio` |
| Local DB | `sqflite` + `path` |
| Session | `shared_preferences` |
| Fonts | `google_fonts` (Poppins) |

### Why Riverpod?

`flutter_riverpod` with `AsyncNotifier` gives compile-safe, testable state management with minimal boilerplate. `AsyncValue` (loading / data / error) maps perfectly to our UI states without manual flag juggling.

### Why sqflite?

Categories are a parent-child relational structure. SQLite's foreign keys give cascading deletes for free, and its support for recursive CTEs makes path queries elegant. sqflite keeps it all on-device with zero network dependency.

---

## Hierarchy Approach

**Flat table with recursive in-Dart build:**

All categories are stored in a single flat table with a `parent_id` column. When displaying the tree, the repository fetches **all rows in one query** and groups them into a `Map<int?, List<Category>>` by `parentId`. A recursive Dart function then builds the tree from that map in **O(n)** — no N+1 queries.

**Recursive CTE for paths:**

The `getPath(id)` method uses a SQLite recursive CTE that walks upward through `parent_id` links until it reaches NULL, then reverses the order to produce root → node. This works for any depth with no additional round trips.

---

## Search & Pagination

- Match: `LOWER(name) LIKE '%query%'`, ordered alphabetically.
- `COUNT(*)` gives `totalCount` before fetching a page.
- `limit` (optional): caps `totalCount` to `min(totalCount, limit)`, so no more than `limit` items are ever returned across all pages.
- Pagination uses SQL `LIMIT / OFFSET` with configurable `pageSize` (default 20).
- For each match on the page, context is built (parent, direct children, root-to-match path) using the full in-memory category map.
- Search is debounced 300 ms in the UI to avoid spamming the database.

---

## Design Decisions

### The NULL-parent duplicate gotcha

SQL `UNIQUE` indexes skip rows where any indexed column is NULL. That means `UNIQUE(parent_id, LOWER(name))` would allow two root categories with the same name (both `parent_id = NULL`). We solve this two ways:

1. **Application-level check** in the repository: `WHERE LOWER(name) = LOWER(?) AND parent_id IS ?` — using `IS` (not `=`) so `NULL IS NULL` evaluates to true.
2. **Safety-net index**: `CREATE UNIQUE INDEX ... ON categories(COALESCE(parent_id, 0), LOWER(name))` — COALESCE maps NULL to 0 (a sentinel that can never be a real ID), making the index cover root nodes correctly.

### Why the tree is built in one pass

Loading all categories once and grouping them in Dart is O(n) and makes exactly one SQL query regardless of tree depth. The alternative — fetching children lazily per node — would produce O(n) queries for an n-node tree (the N+1 problem), which is far worse.

### Why search is paginated but the tree is loaded in full

The tree is always displayed all at once with expand/collapse UX; the user navigates it with interactions, not scrolling through an infinite list. Loading it in full once is the right trade-off for the interactive tree. Search results, however, can be large and are presented as a flat list, so pagination is natural and keeps memory usage bounded.

---

## Running Tests

```bash
flutter test
```

Tests cover:
- Tree building (A→B→C→D→E→F chain, Electronics example)
- Path resolution (root → deep node)
- Duplicate rule (same parent rejected, different parent allowed, case-insensitive)
- Pagination math (limit capping, offset calculation, total pages)
