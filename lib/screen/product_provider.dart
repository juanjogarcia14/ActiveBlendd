import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get cart => _cart;
  List<Map<String, dynamic>> get favorites => _favorites;

  void addToCart(Map<String, dynamic> product) {
    if (!_cart.any((item) => item['title'] == product['title'])) {
      _cart.add({...product, 'quantity': 1});
      notifyListeners();
    }
  }

  void toggleFavorite(Map<String, dynamic> product) {
    if (_favorites.any((item) => item['title'] == product['title'])) {
      _favorites.removeWhere((item) => item['title'] == product['title']);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  void removeFromFavorites(Map<String, dynamic> product) {
    _favorites.removeWhere((item) => item['title'] == product['title']);
    notifyListeners();
  }

}
