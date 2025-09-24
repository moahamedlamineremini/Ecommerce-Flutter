import 'package:flutter/material.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartViewModel {
  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal();

  final ValueNotifier<List<CartItem>> cartItems = ValueNotifier([]);

  void addToCart(Product product, {int quantity = 1}) {
    final items = cartItems.value;
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      items[index].quantity += quantity;
    } else {
      items.add(CartItem(product: product, quantity: quantity));
    }
    cartItems.value = List.from(items);
  }

  void removeFromCart(int productId) {
    final items = cartItems.value;
    items.removeWhere((item) => item.product.id == productId);
    cartItems.value = List.from(items);
  }

  void incrementQuantity(int productId) {
    final items = cartItems.value;
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      items[index].quantity++;
      cartItems.value = List.from(items);
    }
  }

  void decrementQuantity(int productId) {
    final items = cartItems.value;
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0 && items[index].quantity > 1) {
      items[index].quantity--;
      cartItems.value = List.from(items);
    }
  }
}
