import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/user_model.dart';
import '../../../core/providers.dart';

class AuthController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final repo = ref.read(authRepositoryProvider);
    return repo.restoreSession();
  }

  Future<void> login(int id) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repo.login(id));
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(AuthController.new);
