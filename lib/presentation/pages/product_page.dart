// lib/presentation/pages/product_page.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/repositories/catalog_repository.dart';
import 'package:ecommerce_app/data/repositories/catalog_repository_impl.dart';
import 'package:ecommerce_app/data/sources/local_json_source.dart';
import 'package:ecommerce_app/presentation/viewmodels/cart_viewmodel.dart';

class ProductPage extends StatefulWidget {
  final int productId;
  final CatalogRepository? repository;
  /// callback optionnel; l'intégration réelle au panier sera faite par Personne A
  final void Function(Product)? onAddToCart;

  const ProductPage({
    Key? key,
    required this.productId,
    this.repository,
    this.onAddToCart,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<Product?> _productFuture;

  CatalogRepository _repoOrDefault() {
    return widget.repository ?? CatalogRepositoryImpl(localJsonSource: LocalJsonSource());
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
          onPressed: () => Navigator.pop(context),
        ),
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
                    product.images.isNotEmpty ? product.images.first : product.thumbnail,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16),
                Text(product.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(product.description),
                const SizedBox(height: 16),
                Text('Prix: ${product.price} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Ajouter au panier'),
                    onPressed: () {
                      // Utilisation du CartViewModel
                      try {
                        // On suppose que ProductModel et Product sont compatibles
                        // Sinon, il faut adapter la conversion
                        final cartViewModel = CartViewModel();
                        cartViewModel.addToCart(product as dynamic); // cast si besoin
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Produit ajouté au panier')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur: $e')),
                        );
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