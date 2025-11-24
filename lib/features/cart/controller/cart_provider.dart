import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import 'package:client/features/product/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  void addToCart(ProductModel product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItemModel(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.total);
}
