import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'db/database_helper.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/category/data/category_repository.dart';

// ─── Dio ────────────────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

// ─── Database ────────────────────────────────────────────────────────────────

final databaseProvider = FutureProvider<Database>((ref) async {
  return DatabaseHelper.instance.database;
});

// ─── Shared Preferences ──────────────────────────────────────────────────────

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

// ─── Repositories ────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  // SharedPreferences is async — we grab the cached instance.
  // If it's not ready yet, throw to let AsyncNotifier handle it.
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  final prefs = prefsAsync.requireValue;
  return AuthRepository(dio: dio, prefs: prefs);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(databaseProvider).requireValue;
  return CategoryRepository(database: db);
});

