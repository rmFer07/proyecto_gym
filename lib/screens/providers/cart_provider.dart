import 'package:flutter/material.dart';

import '../models/product.dart';


class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void increaseQuantity(String id) {
    final index = _items.indexWhere((p) => p.id == id);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    final index = _items.indexWhere((p) => p.id == id);
    if (index != -1 && _items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    } else {
      removeFromCart(id);
    }
  }

  double get totalPrice {
    return _items.fold(
        0, (total, current) => total + (current.price * current.quantity));
  }
}

extension on Object? {
  // ignore: unused_element
  get id => null;
}
