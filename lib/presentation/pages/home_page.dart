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
        child: ElevatedButton(
          child: const Text('Voir tous les produits'),
          onPressed: () {
            context.go('/products');
          },
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
                  Text('Connecté : ${user.email}', style: const TextStyle(color: Colors.green))
                else
                  Text('Non connecté', style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
          ListTile(
            title: Text('Accueil'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            title: Text('Produits'),
            onTap: () => context.go('/products'),
          ),
          ListTile(
            title: Text('Panier'),
            onTap: () => context.go('/cart'),
          ),
          ListTile(
            title: Text('Historique des commandes'),
            onTap: () => context.go('/order-history'),
          ),
        ],
      ),
    );
  }
}
