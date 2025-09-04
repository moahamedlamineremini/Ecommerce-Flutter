import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/repositories/catalog_repository.dart';
import 'package:ecommerce_app/presentation/pages/product_page.dart';

// Fake repo pour isoler ProductPage
class FakeCatalogRepository implements CatalogRepository {
  final Product product;
  FakeCatalogRepository(this.product);

  @override
  Future<List<Product>> fetchProducts({String? query, String? category}) async {
    return [product];
  }

  @override
  Future<Product?> fetchProduct(int id) async {
    return product.id == id ? product : null;
  }
}

void main() {
  final testProduct = Product(
    id: 1,
    title: 'Test T-shirt',
    price: 19.99,
    thumbnail: '',
    images: ['https://picsum.photos/200/200', 'https://picsum.photos/201/200'],
    description: 'Description test',
    category: 'Vêtements',
  );

  testWidgets('ProductPage displays product info', (WidgetTester tester) async {
    // Monte la page avec le FakeRepo
    await tester.pumpWidget(MaterialApp(
      home: ProductPage(productId: 1, repository: FakeCatalogRepository(testProduct)),
    ));

    // Attendre que FutureBuilder se résolve
    await tester.pumpAndSettle();

    // Vérifie que le titre est affiché
    expect(find.text('Test T-shirt'), findsOneWidget);

    // Vérifie que le prix est affiché
    expect(find.text('19.99 €'), findsOneWidget);

    // Vérifie que le carousel existe (PageView)
    expect(find.byType(PageView), findsOneWidget);

    // Vérifie que le bouton Ajouter au panier existe
    expect(find.text('Ajouter au panier'), findsOneWidget);
  });
}
