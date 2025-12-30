
import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final Category category;
  final double rating; 
  final List<String> sizes; 
  final List<Color> colors; 
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    this.rating = 4.5,
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.colors = const [Colors.black, Colors.blue, Colors.grey],
    this.isFavorite = false,
  });

  String get imageUrl => images.isNotEmpty ? images.first : '';

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> rawImages = List<String>.from(json['images'] ?? []);
    List<String> cleanImages = rawImages.map((img) {
      // Fix potential API formatting issues
      return img.replaceAll('["', '').replaceAll('"]', '').replaceAll('"', '');
    }).toList();

    return Product(
      id: json['id'].toString(), // Convert int ID to String
      name: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      images: cleanImages,
      category: Category.fromJson(json['category']),
      rating: 4.5,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [Colors.black, Colors.white, Colors.blue, Colors.red],
    );
  }
}
