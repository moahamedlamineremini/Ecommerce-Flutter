import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/data/repositories/catalog_repository_impl.dart';
import 'package:ecommerce_app/data/sources/local_json_source.dart';
import 'package:ecommerce_app/data/models/product_model.dart';

class FakeLocalJsonSource extends LocalJsonSource {
  @override
  Future<List<ProductModel>> loadProducts() async {
    return [
      ProductModel(id: 1, title: 'Test', description: 'desc', price: 10.0, thumbnail: '', images: [], category: 'cat'),
      ProductModel(id: 2, title: 'Autre', description: 'autre desc', price: 20.0, thumbnail: '', images: [], category: 'autre'),
    ];
  }
}

void main() {
  group('CatalogRepositoryImpl', () {
    final repo = CatalogRepositoryImpl(localJsonSource: FakeLocalJsonSource());

    test('fetchProducts sans filtre', () async {
      final products = await repo.fetchProducts();
      expect(products.length, 2);
    });

    test('fetchProducts avec filtre catégorie', () async {
      final products = await repo.fetchProducts(category: 'cat');
      expect(products.length, 1);
      expect(products.first.category, 'cat');
    });

    test('fetchProducts avec filtre recherche', () async {
      final products = await repo.fetchProducts(query: 'Autre');
      expect(products.length, 1);
      expect(products.first.title, 'Autre');
    });

    test('fetchProduct par id', () async {
      final product = await repo.fetchProduct(1);
      expect(product, isNotNull);
      expect(product!.id, 1);
    });

    test('fetchProduct id inexistant', () async {
      final product = await repo.fetchProduct(999);
      expect(product, isNull);
    });
  });
}
