import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/providers.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/profile_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Scholigence',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const _RootRouter(),
    );
  }
}

/// Waits for SharedPreferences + DB to load, then routes to Login or Profile.
class _RootRouter extends ConsumerWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sharedPreferencesProvider);
    final dbAsync = ref.watch(databaseProvider);

    // Wait for both async providers to initialise
    if (prefsAsync.isLoading || dbAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (prefsAsync.hasError || dbAsync.hasError) {
      return Scaffold(
        body: Center(
          child: Text(
            'Startup error:\n'
            '${prefsAsync.error ?? dbAsync.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final authState = ref.watch(authControllerProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => const LoginScreen(),
      data: (user) => user != null ? const ProfileScreen() : const LoginScreen(),
    );
  }
}
