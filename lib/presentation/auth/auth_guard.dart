import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import '../catalog/catalog_page.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Transforme un Stream en ChangeNotifier pour GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/catalog', builder: (_, __) => const CatalogPage()),
    ],
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.matchedLocation == '/login';
      if (user == null && !loggingIn) return '/login';
      if (user != null && loggingIn) return '/catalog';
      return null;
    },
  );
}
