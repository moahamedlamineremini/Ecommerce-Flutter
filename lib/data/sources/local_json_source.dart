import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class LocalJsonSource {
  Future<List<ProductModel>> loadProducts() async {
    final data = await rootBundle.loadString('assets/products.json');
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }
}
