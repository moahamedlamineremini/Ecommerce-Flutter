import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/catalog/catalog_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/auth/auth_guard.dart'; // redirect logic (étape 7)
import 'package:ecommerce_app/presentation/pages/home_page.dart';
import 'package:ecommerce_app/presentation/pages/products_page.dart';
import 'package:ecommerce_app/presentation/pages/product_page.dart';
import 'package:ecommerce_app/presentation/pages/cart_page.dart';
import 'package:ecommerce_app/presentation/pages/order_history_page.dart';
import 'presentation/auth/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return MaterialApp.router(
      title: 'Shop Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const CatalogPage(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsPage(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/order-history',
        builder: (context, state) => const OrderHistoryPage(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id != null) {
            return ProductPage(productId: id);
          }
          return const Scaffold(body: Center(child: Text('Product not found')));
        },
      ),
    ],
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final user = container.read(authViewModelProvider);
      final loggedIn = user != null;
      final authRequired = ['/cart', '/order-history', '/products'];
      if (!loggedIn && authRequired.contains(state.uri.toString())) {
        return '/login';
      }
      return null;
    },
  );
}
