
import 'package:flutter/material.dart';
import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  String size;
  Color color;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
