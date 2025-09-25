import '../entities/product.dart';

abstract class CatalogRepository {
  /// Récupère la liste des produits
  /// - Peut filtrer par [query] (dans le titre) ou [category]
  Future<List<Product>> fetchProducts({String? query, String? category});

  /// Récupère un produit précis par son [id]
  Future<Product?> fetchProduct(int id);
}
