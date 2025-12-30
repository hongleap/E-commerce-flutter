
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product, String size, Color color) {
    // Unique ID based on product, size, and color combination
    final cartId = '${product.id}_${size}_${color.value}';

    if (_items.containsKey(cartId)) {
      _items.update(
        cartId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          size: existingCartItem.size,
          color: existingCartItem.color,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        cartId,
        () => CartItem(
          id: DateTime.now().toString(),
          product: product,
          size: size,
          color: color,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String cartId) {
    if (!_items.containsKey(cartId)) {
      return;
    }
    if (_items[cartId]!.quantity > 1) {
      _items.update(
          cartId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                product: existingCartItem.product,
                 size: existingCartItem.size,
                color: existingCartItem.color,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(cartId);
    }
    notifyListeners();
  }

  void removeItem(String cartId) {
    _items.remove(cartId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
