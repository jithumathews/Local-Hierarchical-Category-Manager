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

  /// Fetches user [id] from JSONPlaceholder and persists the session.
  Future<User> login(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = User.fromJson(response.data as Map<String, dynamic>);
      await _prefs.setInt(_kUserIdKey, user.id);
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
      return await login(id);
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
          return 'User not found. Please use an ID from 1 to 10.';
        }
        return 'Server error (${e.response?.statusCode}).';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

