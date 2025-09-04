import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/pages/product_page.dart';

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
      // Pour tester la page produit avec un ID fixe
      home: const ProductPage(productId: 1),
    );
  }
}
