import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/app_exception.dart';
import 'user_model.dart';

const _kUserIdKey = 'logged_in_user_id';

class AuthRepository {
  AuthRepository({required Dio dio, required SharedPreferences prefs})
      : _dio = dio,
        _prefs = prefs;

  final Dio _dio;
  final SharedPreferences _prefs;

  /// Returns the persisted user ID, or null if not logged in.
  int? get persistedUserId => _prefs.getInt(_kUserIdKey);

  /// Authenticates using [username] and [email], matching against JSONPlaceholder users.
  Future<User> loginWithCredentials({
    required String username,
    required String email,
  }) async {
    final cleanUsername = username.trim();
    final cleanEmail = email.trim();

    if (cleanUsername.isEmpty || cleanEmail.isEmpty) {
      throw const AppException('Username and email are required.');
    }

    try {
      final response = await _dio.get('/users');
      final list = (response.data as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();

      final matched = list.where(
        (u) =>
            u.username.trim().toLowerCase() == cleanUsername.toLowerCase() &&
            u.email.trim().toLowerCase() == cleanEmail.toLowerCase(),
      ).firstOrNull;

      if (matched == null) {
        throw const AppException(
          'Invalid username or email. Please check your credentials and try again.',
        );
      }

      await _prefs.setInt(_kUserIdKey, matched.id);
      return matched;
    } on DioException catch (e) {
      throw AppException(_mapDioError(e));
    }
  }

  /// Fetches user by [id] (used for session restoration).
  Future<User> fetchUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = User.fromJson(response.data as Map<String, dynamic>);
      return user;
    } on DioException catch (e) {
      throw AppException(_mapDioError(e));
    }
  }

  /// Fetches user data for the currently persisted session.
  Future<User?> restoreSession() async {
    final id = persistedUserId;
    if (id == null) return null;
    try {
      return await fetchUserById(id);
    } catch (_) {
      return null;
    }
  }

  /// Clears the persisted session.
  Future<void> logout() async {
    await _prefs.remove(_kUserIdKey);
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Check your network.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 404) {
          return 'User not found.';
        }
        return 'Server error (${e.response?.statusCode}).';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
