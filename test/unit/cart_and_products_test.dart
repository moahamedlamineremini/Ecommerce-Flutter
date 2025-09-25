import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/viewmodels/cart_viewmodel.dart';
import 'package:ecommerce_app/presentation/viewmodels/products_viewmodel.dart';
import 'package:ecommerce_app/data/repositories/catalog_repository_impl.dart';
import 'package:ecommerce_app/data/sources/local_json_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CartViewModel', () {
    test('Ajout d\'un produit au panier', () {
      final cart = CartViewModel();
      cart.cartItems.value.clear(); // Nettoyage du panier
      final product = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        thumbnail: 'thumb.png',
        images: ['img1.png'],
        description: '',
        category: ''
      );
      cart.addToCart(product, quantity: 2);
      expect(cart.cartItems.value.length, 1);
      expect(cart.cartItems.value.first.quantity, 2);
    });

    test('Suppression d\'un produit du panier', () {
      final cart = CartViewModel();
      cart.cartItems.value.clear(); // Nettoyage du panier
      final product = Product(
        id: 2,
        title: 'Test2',
        price: 20.0,
        thumbnail: 'thumb2.png',
        images: ['img2.png'],
        description: '',
        category: ''
      );
      cart.addToCart(product);
      cart.removeFromCart(2);
      expect(cart.cartItems.value.isEmpty, true);
    });

    test('Ajout d\'une commande à l\'historique', () {
      final cart = CartViewModel();
      cart.cartItems.value.clear(); // Nettoyage du panier
      cart.orderHistory.value.clear(); // Nettoyage de l'historique
      final product = Product(
        id: 3,
        title: 'Test3',
        price: 30.0,
        thumbnail: 'thumb3.png',
        images: ['img3.png'],
        description: '',
        category: ''
      );
      cart.addToCart(product);
      cart.orderHistory.value.add(Order(items: cart.cartItems.value, totalPrice: 30.0, date: DateTime.now()));
      expect(cart.orderHistory.value.length, 1);
      expect(cart.orderHistory.value.first.totalPrice, 30.0);
    });
  });

  group('ProductsViewModel', () {
    test('Récupération de la liste des produits', () async {
      final viewModel = ProductsViewModel();
      final products = await viewModel.fetchProducts();
      expect(products, isA<List<Product>>());
    });
  });

  group('CatalogRepository', () {
    test('Récupération d\'un produit précis', () async {
      final repo = CatalogRepositoryImpl(localJsonSource: LocalJsonSource());
      final product = await repo.fetchProduct(1);
      expect(product, isA<Product?>());
    });
  });
}
