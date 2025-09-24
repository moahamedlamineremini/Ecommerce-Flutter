import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/pages/widgets/cart_icon.dart';

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
            Navigator.pushNamed(context, '/products');
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
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            title: Text('Produits'),
            onTap: () => Navigator.pushReplacementNamed(context, '/products'),
          ),
          ListTile(
            title: Text('Panier'),
            onTap: () => Navigator.pushReplacementNamed(context, '/cart'),
          ),
        ],
      ),
    );
  }
}
