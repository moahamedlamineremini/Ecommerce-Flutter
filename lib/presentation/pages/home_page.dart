import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/pages/widgets/cart_icon.dart';
import 'package:go_router/go_router.dart';

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

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Menu')),
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
