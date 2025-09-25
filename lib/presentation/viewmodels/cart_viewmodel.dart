import 'package:flutter/material.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class Order {
  final List<CartItem> items;
  final double totalPrice;
  final DateTime date;
  Order({required this.items, required this.totalPrice, required this.date});
}

class CartViewModel {
  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal();

  final ValueNotifier<List<CartItem>> cartItems = ValueNotifier([]);
  final ValueNotifier<List<Order>> orderHistory = ValueNotifier([]);

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

  void placeOrder() {
    final items = List<CartItem>.from(cartItems.value);
    if (items.isEmpty) return;
    double totalPrice = items.fold(0, (sum, item) => sum + item.quantity * item.product.price);
    orderHistory.value = List.from(orderHistory.value)
      ..add(Order(items: items, totalPrice: totalPrice, date: DateTime.now()));
    cartItems.value = [];
  }
}
