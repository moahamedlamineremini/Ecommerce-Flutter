import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/viewmodels/cart_viewmodel.dart';
import 'package:go_router/go_router.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = CartViewModel();
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: cartViewModel.cartItems,
      builder: (context, items, _) {
        int count = items.fold(0, (sum, item) => sum + item.quantity);
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => context.go('/cart'),
            ),
            if (count > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
