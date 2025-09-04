import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/repositories/catalog_repository.dart';
import '../sources/local_json_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final LocalJsonSource localJsonSource;

  CatalogRepositoryImpl({required this.localJsonSource});

  @override
  Future<List<Product>> fetchProducts({String? query, String? category}) async {
    final models = await localJsonSource.loadProducts();
    var products = models.map((m) => m.toEntity()).toList();

    // Filtrage par catégorie
    if (category != null && category.isNotEmpty) {
      products = products.where((p) => p.category == category).toList();
    }

    // Filtrage par recherche
    if (query != null && query.isNotEmpty) {
      products = products
          .where((p) =>
      p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return products;
  }

  @override
  Future<Product?> fetchProduct(int id) async {
    final models = await localJsonSource.loadProducts();
    try {
      final model = models.firstWhere((m) => m.id == id);
      return model.toEntity();
    } catch (_) {
      return null;
    }
  }
}
