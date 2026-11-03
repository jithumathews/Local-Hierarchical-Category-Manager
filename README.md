# Scholigence — Local Hierarchical Category Manager

A cross-platform Flutter application featuring mock authentication via JSONPlaceholder, a user profile screen, and an unlimited-depth hierarchical category tree stored locally in SQLite with multi-tenant isolation, recursive search, pagination, and a modern black-and-white minimalist design.

---

## 1. Setup Instructions

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.10+ / Dart 3.10+)
- Android Studio / Xcode / VS Code configured with Flutter and Dart extensions
- Connected device, simulator/emulator, or desktop target (Windows / macOS / Linux)

### Installation & Execution

```bash
# 1. Clone the repository and navigate into the project directory
cd scholigence

# 2. Install dependencies
flutter pub get

# 3. Generate Freezed and JSON serialization files
dart run build_runner build --delete-conflicting-outputs

# 4. Run static analysis (verifies zero warnings/errors)
flutter analyze

# 5. Run automated unit tests
flutter test

# 6. Launch the application
flutter run
```

### Demo Credentials
Login authenticates against the live JSONPlaceholder `/users` API:
- **Username:** `Bret` | **Email:** `Sincere@april.biz` *(User ID 1)*
- **Username:** `Antonette` | **Email:** `Shanna@melissa.tv` *(User ID 2)*
- *(Any of the 10 JSONPlaceholder users can be used. Entering incorrect credentials triggers an animated top alert SnackBar).*

---

## 2. Project Architecture

The application adopts a **3-Layer Architecture** (Presentation → Repository → Data Source) without unnecessary use-case abstractions:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   Flutter Widgets (M3 UI) + Riverpod Controllers       │
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│                    Repository Layer                    │
│   Business logic, validations, tree & path algorithms, │
│   SQL queries, error mapping (AppException)           │
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│                   Data Source Layer                    │
│   Dio (Remote HTTP REST API) & sqflite (Local SQLite) │
└────────────────────────────────────────────────────────┘
```

### Directory Structure

```
lib/
├── main.dart                          # App entry point with ProviderScope
├── app.dart                           # MaterialApp, theme configuration & root router
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # Black & white minimalist M3 light/dark themes
│   ├── error/
│   │   └── app_exception.dart         # User-friendly custom exception class
│   ├── db/
│   │   └── database_helper.dart       # SQLite database initialization, PRAGMA & indexes
│   └── providers.dart                 # Global Riverpod providers (Dio, DB, Repos)
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── user_model.dart        # Freezed + json_serializable User & Company models
    │   │   └── auth_repository.dart   # JSONPlaceholder API auth & session persistence
    │   └── presentation/
    │       ├── auth_controller.dart   # AsyncNotifier for user auth session
    │       ├── login_screen.dart      # Login UI with top animated error SnackBar
    │       └── profile_screen.dart    # User profile & session logout
    └── category/
        ├── data/
        │   ├── category_model.dart    # Category, CategoryNode, PagedResult models
        │   └── category_repository.dart # SQLite queries, O(n) tree & CTE path logic
        └── presentation/
            ├── category_controller.dart # CategoryTreeNotifier, search & filter providers
            ├── category_screen.dart   # Category tree & search screen with limit chips
            └── widgets/
                ├── category_tree_tile.dart  # Recursive tree tile with expand/collapse
                ├── search_result_card.dart  # Search result card with breadcrumb & mini-tree
                ├── add_category_dialog.dart # Add category / subcategory dialog
                ├── empty_state.dart         # Reusable empty state view
                └── error_view.dart          # Error & retry view
```

---

## 3. State-Management Approach

The project utilizes **`flutter_riverpod`** with explicit `Notifier` and `AsyncNotifier` classes (without code generation for providers):

- **Compile-time safety & declarative data flow:** Riverpod provides dependency injection and reactive state synchronization across the app without `BuildContext` coupling.
- **`AsyncNotifier` for async operations:** Used in `AuthController` and `CategoryTreeNotifier`. State is modeled using `AsyncValue<T>` (`loading`, `data`, `error`), eliminating manual boolean flags.
- **Reactive UI updates:** When mutations occur (e.g., adding or deleting a category), calling `ref.invalidateSelf()` causes the tree to re-fetch and rebuild automatically.
- **Provider composition:** Search results reactively depend on `searchQueryProvider`, `searchPageProvider`, `searchLimitProvider`, and the logged-in user:
  ```dart
  final searchResultsProvider = FutureProvider<PagedResult<CategorySearchResult>>((ref) async {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final query = ref.watch(searchQueryProvider);
    final page = ref.watch(searchPageProvider);
    final limit = ref.watch(searchLimitProvider);
    ...
  });
  ```

---

## 4. Local Database Selection

The local database of choice is **SQLite** via **`sqflite`**:

- **Relational Parent-Child fit:** Hierarchical category data is naturally relational. Storing nodes with `parent_id REFERENCES categories(id)` aligns with relational database capabilities.
- **Foreign Keys & Cascading Deletes:** By executing `PRAGMA foreign_keys = ON` in `onConfigure`, deleting any parent node automatically deletes its entire child subtree in SQLite via `ON DELETE CASCADE`.
- **Recursive CTE Support:** SQLite natively supports Common Table Expressions (`WITH RECURSIVE`), enabling single-query upward ancestral path traversal from any leaf to root.
- **Indexed performance:** Dedicated indexes on `user_id`, `parent_id`, and `LOWER(name)` guarantee $O(\log n)$ queries even as datasets grow.

---

## 5. Category Hierarchy Implementation

### Single-Pass $O(n)$ Tree Construction
Rather than executing recursive $N+1$ database queries (which would result in high query latency on deep trees), the repository loads all user-scoped categories in a **single query**:
1. Fetches all categories for the current user: `SELECT * FROM categories WHERE user_id = ? ORDER BY name ASC`.
2. Groups categories in-memory into a `Map<int?, List<Category>>` keyed by `parent_id`.
3. Recursively constructs `CategoryNode` trees beginning from `parent_id = null` (roots) down through leaves.
4. **Time Complexity:** $O(n)$, making tree building instant for arbitrary depths (e.g., 6+ level chains).

### Ancestor Path Traversal via Recursive CTE
To resolve the full breadcrumb path from root to any arbitrary node (e.g., `Electronics › Mobile › Android › Samsung`), `getPath` executes a recursive Common Table Expression in SQLite:
```sql
WITH RECURSIVE ancestors(id, user_id, name, parent_id, created_at, depth) AS (
  SELECT id, user_id, name, parent_id, created_at, 0
  FROM categories WHERE id = ? AND user_id = ?
  UNION ALL
  SELECT c.id, c.user_id, c.name, c.parent_id, c.created_at, a.depth + 1
  FROM categories c
  JOIN ancestors a ON c.id = a.parent_id
  WHERE c.user_id = ?
)
SELECT id, user_id, name, parent_id, created_at FROM ancestors
ORDER BY depth DESC;
```
Dart also features an in-memory parent-pointer lookup function (`_buildPath`) used for batch-populating search result cards.

---

## 6. Search and Pagination Approach

### Case-Insensitive Substring Match
Search operates across all category names using SQL pattern matching:
`WHERE user_id = ? AND LOWER(name) LIKE '%query%' ORDER BY name ASC`.

### Total Count & Optional Limit
1. **Total Count:** `SELECT COUNT(*) ...` determines the total matches matching the query.
2. **Limit Parameter:** An optional user-selected `limit` (e.g., 10, 20, 50, or None) caps the effective total count to `min(totalCount, limit)`.
3. **Pagination:** Items are fetched using standard SQL `LIMIT` and `OFFSET`:
   `offset = (page - 1) * pageSize`.
4. Results are wrapped in a generic `PagedResult<CategorySearchResult>` containing `items`, `page`, `pageSize`, and `totalCount`.

### Enriched Search Context
For each matched item on the page, the repository assembles:
- **`match`**: The matching category entity.
- **`parent`**: Direct parent category (if any).
- **`children`**: List of immediate subcategories.
- **`path`**: Full ancestral chain from root to match.

### UI Debouncing
Input on the `SearchBar` is debounced by **300ms** to prevent redundant database queries while the user is typing.

---

## 7. Additional Architectural Decisions

### Multi-Tenancy (Data Isolation)
Categories are strictly scoped to the authenticated user via `user_id`:
- Uniqueness constraint: `UNIQUE(user_id, COALESCE(parent_id, 0), LOWER(name))`.
- Different users can have identical category names without collisions.
- Logging out clears the state; logging in with another account displays only that account's categories.

### The NULL-Parent Duplicate Gotcha
SQL `UNIQUE` constraints ignore `NULL` values. To prevent duplicate root categories under the same parent (`parent_id IS NULL`), two safeguards are implemented:
1. Application-level check: `WHERE user_id = ? AND LOWER(name) = LOWER(?) AND parent_id IS ?` (using SQL `IS` instead of `=`).
2. Database index safety net: `CREATE UNIQUE INDEX ... ON categories(user_id, COALESCE(parent_id, 0), LOWER(name))` where `COALESCE` maps `NULL` to `0`.

### Black & White Minimalist UI
The user interface implements a monochrome design system inspired by modern tools (Vercel, Linear):
- Crisp white surfaces (`#FFFFFF`) with neutral zinc borders (`#E4E4E7`).
- Deep pitch black (`#09090B`) primary buttons and interactive accents.
- Animated top-floating alert SnackBar for invalid authentication credentials.
