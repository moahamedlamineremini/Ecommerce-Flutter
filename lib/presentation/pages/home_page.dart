import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/pages/widgets/cart_icon.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/presentation/auth/auth_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil'), actions: [const CartIcon()]),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicateur visuel pour le test Blue-Green
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: Colors.blue, size: 12),
                  SizedBox(width: 8),
                  Text(
                    'BLUE DEPLOYMENT - TEST',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Voir tous les produits'),
              onPressed: () {
                context.go('/products');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Menu', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (user != null)
                  Text(
                    'Connecté : ${user.email}',
                    style: const TextStyle(color: Colors.green),
                  )
                else
                  Text(
                    'Non connecté',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          ListTile(title: Text('Accueil'), onTap: () => context.go('/')),
          ListTile(
            title: Text('Produits'),
            onTap: () => context.go('/products'),
          ),
          ListTile(title: Text('Panier'), onTap: () => context.go('/cart')),
          ListTile(
            title: Text('Historique des commandes'),
            onTap: () => context.go('/order-history'),
          ),
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Déconnexion'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final navigator = GoRouter.of(context);
                  await ref.read(authViewModelProvider.notifier).signOut();
                  navigator.go('/login');
                },
              ),
            ),
        ],
      ),
    );
  }
}
