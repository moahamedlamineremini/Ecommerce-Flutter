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
          double totalPrice = items.fold(0, (sum, item) => sum + item.quantity * item.product.price);
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantité: ${item.quantity}'),
                          Text('Prix: ${(item.product.price * item.quantity).toStringAsFixed(2)} €'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => viewModel.decrementQuantity(item.product.id),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => viewModel.incrementQuantity(item.product.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => viewModel.removeFromCart(item.product.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Prix total :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${totalPrice.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text('Passer la commande'),
                        onPressed: () {
                          viewModel.placeOrder();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Paiement Stripe'),
                              content: const Text('Paiement réussi ! (test Stripe)\nVotre commande a été enregistrée.'),
                              actions: [
                                TextButton(
                                  child: const Text('Voir l\'historique'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(context, '/order-history');
                                  },
                                ),
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
