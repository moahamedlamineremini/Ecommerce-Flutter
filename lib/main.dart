import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/pages/home_page.dart';
import 'package:ecommerce_app/presentation/pages/products_page.dart';
import 'package:ecommerce_app/presentation/pages/product_page.dart';
import 'package:ecommerce_app/presentation/pages/cart_page.dart';
import 'package:ecommerce_app/presentation/pages/order_history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/products': (context) => const ProductsPage(),
        '/cart': (context) => const CartPage(),
        '/order-history': (context) => const OrderHistoryPage(),
      },
      // Pour la page produit, on utilise onGenerateRoute pour passer l'ID dynamiquement
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/product/') ?? false) {
          final idStr = settings.name!.split('/').last;
          final id = int.tryParse(idStr);
          if (id != null) {
            return MaterialPageRoute(
              builder: (_) => ProductPage(productId: id),
            );
          }
        }
        return null;
      },
    );
  }
}
