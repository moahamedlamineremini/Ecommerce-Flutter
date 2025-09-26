// lib/presentation/pages/product_page.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/repositories/catalog_repository.dart';
import 'package:ecommerce_app/data/repositories/catalog_repository_impl.dart';
import 'package:ecommerce_app/data/sources/local_json_source.dart';
import 'package:ecommerce_app/presentation/viewmodels/cart_viewmodel.dart';
import 'package:ecommerce_app/presentation/pages/widgets/cart_icon.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatefulWidget {
  final int productId;
  final CatalogRepository? repository;

  /// callback optionnel; l'intégration réelle au panier sera faite par Personne A
  final void Function(Product)? onAddToCart;

  const ProductPage({
    super.key,
    required this.productId,
    this.repository,
    this.onAddToCart,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<Product?> _productFuture;
  int _quantity = 1;

  CatalogRepository _repoOrDefault() {
    return widget.repository ??
        CatalogRepositoryImpl(localJsonSource: LocalJsonSource());
  }

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    final repo = _repoOrDefault();
    _productFuture = repo.fetchProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du produit'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [const CartIcon()],
      ),
      body: FutureBuilder<Product?>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Produit non trouvé'));
          }
          final product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    product.images.isNotEmpty
                        ? product.images.first
                        : product.thumbnail,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(product.description),
                const SizedBox(height: 16),
                Text(
                  'Prix: ${product.price} €',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Quantité :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => _quantity++);
                      },
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Ajouter au panier'),
                    onPressed: () {
                      try {
                        final cartViewModel = CartViewModel();
                        cartViewModel.addToCart(product, quantity: _quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$_quantity produit(s) ajouté(s) au panier',
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}