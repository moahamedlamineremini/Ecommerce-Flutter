import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/presentation/pages/products_page.dart';

void main() {
  testWidgets('ProductsPage affiche le titre, le bouton retour et le loader', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProductsPage()));
    expect(find.text('Tous les produits'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
