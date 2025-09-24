import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/pages/home_page.dart';
import 'package:ecommerce_app/presentation/viewmodels/cart_viewmodel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = CartViewModel();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: const AppDrawer(),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: viewModel.cartItems,
        builder: (context, items, _) {
          int total = items.fold(0, (sum, item) => sum + item.quantity);
          if (items.isEmpty) {
            return const Center(child: Text('Votre panier est vide'));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 8),
                    Text('Articles dans le panier : $total', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Image.network(
                        item.product.images.isNotEmpty ? item.product.images.first : item.product.thumbnail,
                        width: 50, height: 50),
                      title: Text(item.product.title),
                      subtitle: Text('Quantité: ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => viewModel.removeFromCart(item.product.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
