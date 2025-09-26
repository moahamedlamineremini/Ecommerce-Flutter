import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/presentation/pages/products_page.dart';
import 'package:ecommerce_app/presentation/pages/widgets/cart_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('ProductsPage affiche le titre et le bouton retour', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: ProductsPage())),
    );
    expect(find.text('Tous les produits'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(CartIcon), findsOneWidget);
  });
}
