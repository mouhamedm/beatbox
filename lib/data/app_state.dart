import 'package:flutter/material.dart';
import 'mock_products.dart';
import 'product.dart';

class CartItem {
  CartItem({
    required this.product,
    this.quantity = 1,
    this.colorName = 'Matte Black',
  });

  final Product product;
  int quantity;
  String colorName;
}

class AppState extends ChangeNotifier {
  AppState._() {
    // Initial mock cart items & favorites so screens look alive immediately!
    if (mockProducts.isNotEmpty) {
      _favorites.add(mockProducts[0].id);
      if (mockProducts.length > 1) {
        _favorites.add(mockProducts[1].id);
        _cart.add(CartItem(product: mockProducts[0], quantity: 1, colorName: 'Deep Crimson'));
        _cart.add(CartItem(product: mockProducts[1], quantity: 2, colorName: 'Matte Black'));
      }
    }
  }

  static final AppState instance = AppState._();

  final Set<String> _favorites = {};
  final List<CartItem> _cart = [];
  String? _appliedPromo;
  double _discountPercent = 0.0;

  List<Product> get favoriteProducts =>
      mockProducts.where((p) => _favorites.contains(p.id)).toList();

  List<CartItem> get cartItems => List.unmodifiable(_cart);

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  bool isFavorite(String productId) => _favorites.contains(productId);

  void toggleFavorite(Product product) {
    if (_favorites.contains(product.id)) {
      _favorites.remove(product.id);
    } else {
      _favorites.add(product.id);
    }
    notifyListeners();
  }

  void addToCart(Product product, {String colorName = 'Matte Black', int quantity = 1}) {
    final existingIndex = _cart.indexWhere(
      (item) => item.product.id == product.id && item.colorName == colorName,
    );
    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, quantity: quantity, colorName: colorName));
    }
    notifyListeners();
  }

  void updateCartQty(CartItem item, int delta) {
    item.quantity += delta;
    if (item.quantity <= 0) {
      _cart.remove(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _appliedPromo = null;
    _discountPercent = 0.0;
    notifyListeners();
  }

  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == 'BEAT20') {
      _appliedPromo = 'BEAT20';
      _discountPercent = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  String? get appliedPromo => _appliedPromo;
  double get discountPercent => _discountPercent;

  double get subtotal =>
      _cart.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

  double get discountAmount => subtotal * _discountPercent;

  double get total => (subtotal - discountAmount).clamp(0.0, double.infinity);
}
