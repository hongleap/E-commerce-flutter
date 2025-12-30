
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/review.dart';

class MockData {
  // Keeping this for reference, though HomeScreen now uses API
  static List<Product> products = [
    Product(
      id: '1',
      name: 'Minimalist Cotton Tee',
      description: 'A premium quality cotton t-shirt designed for everyday comfort. Features a relaxed fit and breathable fabric.',
      price: 25.00,
      images: ['https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'],
      category: Category(id: 1, name: 'Men', image: ''),
      rating: 4.5,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: [Colors.black, Colors.white, Colors.grey],
    ),
    Product(
      id: '2',
      name: 'Summer Floral Dress',
      description: 'Elegant floral dress perfect for summer outings. Lightweight and airy design.',
      price: 45.00,
      images: ['https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'],
       category: Category(id: 2, name: 'Women', image: ''),
      rating: 4.8,
      sizes: ['XS', 'S', 'M', 'L'],
      colors: [Colors.redAccent, Colors.blueAccent],
    ),
  ];

  static List<Review> reviews = [
    Review(
      id: '1',
      userName: 'John Doe',
      userImage: 'https://i.pravatar.cc/150?u=1',
      rating: 5.0,
      comment: 'Amazing quality! Fits perfectly.',
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Review(
      id: '2',
      userName: 'Jane Smith',
      userImage: 'https://i.pravatar.cc/150?u=2',
      rating: 4.0,
      comment: 'Good, but delivery was a bit slow.',
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Review(
      id: '3',
      userName: 'Alex Johnson',
      userImage: 'https://i.pravatar.cc/150?u=3',
      rating: 4.5,
      comment: 'Love the material. Very comfortable.',
      date: DateTime.now().subtract(Duration(days: 10)),
    ),
  ];
}
