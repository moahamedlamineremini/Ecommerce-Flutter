import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/viewmodels/cart_viewmodel.dart';

void main() {
  group('CartViewModel', () {
    final cart = CartViewModel();
    final product = Product(
      id: 1,
      title: 'Test',
      price: 10.0,
      thumbnail: 'thumb.png',
      images: [],
      description: '',
      category: '',
    );

    setUp(() {
      cart.cartItems.value.clear();
    });

    test('Ajout d\'un produit au panier', () {
      cart.addToCart(product);
      expect(cart.cartItems.value.length, 1);
      expect(cart.cartItems.value.first.product.id, 1);
    });

    test('Ajout de quantité à un produit existant', () {
      cart.addToCart(product);
      cart.addToCart(product, quantity: 2);
      expect(cart.cartItems.value.first.quantity, 3);
    });

    test('Suppression d\'un produit du panier', () {
      cart.addToCart(product);
      cart.removeFromCart(product.id);
      expect(cart.cartItems.value.isEmpty, true);
    });
  });
}
