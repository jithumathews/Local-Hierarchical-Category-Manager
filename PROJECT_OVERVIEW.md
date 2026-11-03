# Scholigence — Project Overview & Architecture Documentation

## 1. Setup Instructions

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.10+ / Dart 3.10+)
- IDE: VS Code / Android Studio / IntelliJ with Flutter & Dart plugins
- Device / Emulator / Simulator / Desktop target

### Step-by-Step Setup

```bash
# 1. Navigate to the project root
cd scholigence

# 2. Fetch packages
flutter pub get

# 3. Run build_runner code generation (Freezed & JSON serializable)
dart run build_runner build --delete-conflicting-outputs

# 4. Verify code quality (zero warnings or issues)
flutter analyze

# 5. Run automated unit tests
flutter test

# 6. Launch the app
flutter run
```

### Authentication Test Credentials
Authenticate with credentials from JSONPlaceholder:
- **Username:** `Bret` | **Email:** `Sincere@april.biz` (User 1)
- **Username:** `Antonette` | **Email:** `Shanna@melissa.tv` (User 2)
*(Wrong credentials display an animated top alert SnackBar).*

---

## 2. Brief Explanation of Core Concerns

### Project Architecture
The project follows a clean **3-layer architecture**:
- **Presentation Layer:** Flutter widgets (Material 3) and Riverpod controllers (`AsyncNotifier` / `Notifier`).
- **Repository Layer:** Business logic, tree construction, ancestral path resolution, input validation, and SQLite queries.
- **Data Source Layer:** External Dio HTTP client and local SQLite (`sqflite`) instance.
*Data flows strictly in one direction (Presentation → Repository → Data Source); the UI never touches SQL or HTTP directly.*

### State-Management Approach
- **Choice:** `flutter_riverpod` (v2.6.x) with manual `Notifier` and `AsyncNotifier` (no code-generation for providers).
- **Asynchronous Handling:** Models state as `AsyncValue<T>` (`data`, `loading`, `error`), giving type-safe error boundaries and progress states out of the box.
- **Reactivity:** Mutations in `CategoryTreeNotifier` call `ref.invalidateSelf()` to refresh the tree automatically. Search results reactively watch query, page, limit, and the authenticated user ID.

### Local Database Selection
- **Choice:** SQLite via `sqflite` + `path`.
- **Relational Fit:** Perfect for parent-child tree relationships (`parent_id REFERENCES categories(id)`).
- **Cascading Deletes:** `PRAGMA foreign_keys = ON` enables automatic recursive sub-tree deletion when a parent category is removed (`ON DELETE CASCADE`).
- **Recursive CTEs:** SQLite's `WITH RECURSIVE` queries execute fast single-query ancestor path lookups from any depth.
- **Performance:** B-tree indexes on `user_id`, `parent_id`, and `LOWER(name)`.

### Category Hierarchy Implementation
- **Single-Query $O(n)$ Tree Construction:** The repository retrieves all rows for the active user in a single `SELECT * FROM categories WHERE user_id = ? ORDER BY name ASC` query, groups them into an in-memory `Map<int?, List<Category>>` by `parentId`, and builds `CategoryNode` trees recursively starting at root (`parentId == null`). This completely prevents the $N+1$ query problem.
- **Ancestral Path Traversal:** A recursive CTE (`getPath`) walks up through `parent_id` pointers until reaching `NULL` and orders results `depth DESC` to return the complete path (Root → Node) for any depth.

### Search and Pagination Approach
- **Matching:** Case-insensitive substring query: `WHERE user_id = ? AND LOWER(name) LIKE '%query%'`.
- **Total Count & Limit:** `COUNT(*)` counts total matching records. An optional user-selected `limit` parameter caps `min(totalCount, limit)`.
- **Pagination:** Paged using SQL `LIMIT` and `OFFSET` (`(page - 1) * pageSize`).
- **Contextual Results:** Each search match in `PagedResult<CategorySearchResult>` is enriched with its parent, children, and root-to-match path.
- **Debounce:** Search text input is debounced by **300ms** in the UI to prevent database thrashing.

