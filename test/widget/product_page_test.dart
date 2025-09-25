import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/presentation/pages/product_page.dart';

void main() {
  testWidgets('ProductPage affiche le loader au chargement', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ProductPage(productId: 1),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

