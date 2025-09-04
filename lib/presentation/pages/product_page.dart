// lib/presentation/pages/product_page.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/repositories/catalog_repository.dart';
import 'package:ecommerce_app/data/repositories/catalog_repository_impl.dart';
import 'package:ecommerce_app/data/sources/local_json_source.dart';

class ProductPage extends StatelessWidget {
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

  CatalogRepository _repoOrDefault() {
    return repository ?? CatalogRepositoryImpl(localJsonSource: LocalJsonSource());
  }

  @override
  Widget build(BuildContext context) {
    final repo = _repoOrDefault();

    return Scaffold(
      appBar: AppBar(title: const Text('Détail produit')),
      body: FutureBuilder<Product?>(
        future: repo.fetchProduct(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final product = snapshot.data;
          if (product == null) {
            return const Center(child: Text('Produit introuvable'));
          }

          return _ProductView(product: product, onAddToCart: onAddToCart);
        },
      ),
    );
  }
}

class _ProductView extends StatefulWidget {
  final Product product;
  final void Function(Product)? onAddToCart;
  const _ProductView({required this.product, this.onAddToCart});

  @override
  State<_ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<_ProductView> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel simple
          SizedBox(
            height: 320,
            child: PageView.builder(
              itemCount: p.images.length,
              onPageChanged: (i) => setState(() => pageIndex = i),
              itemBuilder: (context, i) {
                final url = p.images[i];
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (c, e, s) => const Center(child: Icon(Icons.broken_image)),
                );
              },
            ),
          ),
          // indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text('${pageIndex + 1} / ${p.images.length}', style: const TextStyle(fontSize: 12)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(p.title, style: Theme.of(context).textTheme.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text('${p.price.toStringAsFixed(2)} €', style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(p.description),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Ajouter au panier'),
                    onPressed: () {
                      if (widget.onAddToCart != null) {
                        widget.onAddToCart!(p);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajouté au panier')));
                      } else {
                        // Integration TODO for Personne A
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('TODO: intégrer au panier (personne A)')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  child: const Text('Retour'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
