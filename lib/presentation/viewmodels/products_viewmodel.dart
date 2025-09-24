import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/data/repositories/catalog_repository_impl.dart';
import 'package:ecommerce_app/data/sources/local_json_source.dart';

class ProductsViewModel {
  final _repo = CatalogRepositoryImpl(localJsonSource: LocalJsonSource());

  Future<List<Product>> fetchProducts() async {
    return await _repo.fetchProducts();
  }
}
