import '../../domain/entities/product.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final List<String> images;
  final String description;
  final String category;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.description,
    required this.category,
  });

  // JSON → Model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      images: List<String>.from(json['images']),
      description: json['description'] as String,
      category: json['category'] as String,
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'images': images,
      'description': description,
      'category': category,
    };
  }

  // Model → Entity
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      thumbnail: thumbnail,
      images: images,
      description: description,
      category: category,
    );
  }
}
