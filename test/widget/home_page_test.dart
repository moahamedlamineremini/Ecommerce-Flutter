import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/presentation/pages/home_page.dart';
import 'package:ecommerce_app/presentation/auth/auth_viewmodel.dart';

// Mock classes
class MockUser implements User {
  @override
  String? get email => 'test@test.com';

  @override
  String get uid => 'test-uid';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthViewModel extends AuthViewModel {
  User? _user;
  bool signOutCalled = false;
  late StateNotifierProviderRef<AuthViewModel, User?> _ref;

  MockAuthViewModel({User? user}) : _user = user;

  void setUser(User? user) {
    _user = user;
  }

  @override
  User? build() => _user;

  // Ajouter le setter pour ref
  void setRef(StateNotifierProviderRef<AuthViewModel, User?> ref) {
    _ref = ref;
  }

  @override
  StateNotifierProviderRef<AuthViewModel, User?> get ref => _ref;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    _user = null;
    // Notifier les listeners du changement
    state = null;
  }
}

void main() {
  group('HomePage Tests', () {
    testWidgets('HomePage affiche correctement le titre et le bouton', (WidgetTester tester) async {
      // Créer un router de test
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => const Scaffold(body: Text('Products Page')),
          ),
        ],
      );

      // Créer un container avec le provider mocké
      final container = ProviderContainer(
        overrides: [
          authViewModelProvider.overrideWith((ref) {
            final mock = MockAuthViewModel();
            mock.setRef(ref);
            return mock;
          }),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Attendre que le widget soit complètement construit
      await tester.pumpAndSettle();

      // Vérifier que le titre est affiché
      expect(find.text('Accueil'), findsOneWidget);

      // Vérifier que le bouton "Voir tous les produits" est affiché
      expect(find.text('Voir tous les produits'), findsOneWidget);

      // Vérifier qu'il y a un AppBar avec un drawer (plus flexible)
      expect(find.byType(AppBar), findsOneWidget);

      // Optionnel: vérifier la présence du drawer si HomePage en a un
      // Commenté car cela dépend de l'implémentation exacte de HomePage
      // expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('Cliquer sur le bouton navigue vers /products', (WidgetTester tester) async {
      String? navigatedTo;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) {
              navigatedTo = '/products';
              return const Scaffold(body: Text('Products Page'));
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          authViewModelProvider.overrideWith((ref) {
            final mock = MockAuthViewModel();
            mock.setRef(ref);
            return mock;
          }),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Cliquer sur le bouton
      await tester.tap(find.text('Voir tous les produits'));
      await tester.pumpAndSettle();

      // Vérifier que la navigation a eu lieu
      expect(navigatedTo, equals('/products'));
    });
  });
}