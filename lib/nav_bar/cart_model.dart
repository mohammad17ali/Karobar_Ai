import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  void updateItemQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((item) => item['id'] == itemId);
    if (index != -1) {
      _items[index]['fields']['Quantity'] = quantity;
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item['id'] == itemId);
    notifyListeners();
  }
}
