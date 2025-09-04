import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import '../catalog/catalog_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/catalog', builder: (_, __) => const CatalogPage()),
    ],
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.name == 'login';
      if (user == null && !loggingIn) return '/login';
      if (user != null && loggingIn) return '/catalog';
      return null;
    },
  );
}
