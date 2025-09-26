import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/viewmodels/cart_viewmodel.dart';
import 'package:go_router/go_router.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = CartViewModel();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des commandes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ValueListenableBuilder<List<Order>>(
        valueListenable: viewModel.orderHistory,
        builder: (context, orders, _) {
          if (orders.isEmpty) {
            return const Center(child: Text('Aucune commande passée'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    'Commande du ${order.date.day}/${order.date.month}/${order.date.year}',
                  ),
                  subtitle: Text(
                    'Articles: ${order.items.length}\nPrix total: ${order.totalPrice.toStringAsFixed(2)} €',
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Détail de la commande'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...order.items.map(
                              (item) => Text(
                                '${item.product.title} x${item.quantity} - ${(item.product.price * item.quantity).toStringAsFixed(2)} €',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total: ${order.totalPrice.toStringAsFixed(2)} €',
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Fermer'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
