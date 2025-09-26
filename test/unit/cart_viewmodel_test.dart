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
      cart.orderHistory.value.clear();
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

    test('incrementQuantity augmente la quantité', () {
      cart.addToCart(product);
      cart.incrementQuantity(product.id);
      expect(cart.cartItems.value.first.quantity, 2);
    });

    test('decrementQuantity diminue la quantité', () {
      cart.addToCart(product, quantity: 3);
      cart.decrementQuantity(product.id);
      expect(cart.cartItems.value.first.quantity, 2);
    });

    test('decrementQuantity ne diminue pas en dessous de 1', () {
      cart.addToCart(product, quantity: 1);
      cart.decrementQuantity(product.id);
      expect(cart.cartItems.value.first.quantity, 1);
    });

    test('placeOrder ajoute une commande et vide le panier', () {
      cart.addToCart(product, quantity: 2);
      cart.placeOrder();
      expect(cart.orderHistory.value.length, 1);
      expect(cart.cartItems.value.isEmpty, true);
      expect(cart.orderHistory.value.first.totalPrice, 20.0);
    });

    test('placeOrder ne fait rien si le panier est vide', () {
      final initialOrderCount = cart.orderHistory.value.length;
      cart.placeOrder();
      expect(cart.orderHistory.value.length, initialOrderCount);
    });
  });
}
