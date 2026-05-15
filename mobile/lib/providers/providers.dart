import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.login(email, password);
      _user = User.fromJson(data['user']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
      );
      _user = User.fromJson(data['user']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    try {
      _user = await _apiService.getMe();
    } catch (_) {
      _user = null;
    }
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  final ProductVariation variation;
  final List<Modifier> selectedModifiers;
  int quantity;

  CartItem({
    required this.product,
    required this.variation,
    required this.selectedModifiers,
    this.quantity = 1,
  });

  double get totalPrice {
    double base = variation.priceDouble;
    double modifiersTotal = selectedModifiers.fold(0, (sum, m) => sum + m.priceDouble);
    return (base + modifiersTotal) * quantity;
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product, ProductVariation variation, List<Modifier> modifiers) {
    // Check if exactly the same item exists
    final index = _items.indexWhere((i) => 
      i.product.id == product.id && 
      i.variation.id == variation.id && 
      i.selectedModifiers.map((m) => m.id).join(',') == modifiers.map((m) => m.id).join(',')
    );

    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(
        product: product,
        variation: variation,
        selectedModifiers: modifiers,
      ));
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  List<Map<String, dynamic>> toApiJson() {
    return _items.map((item) => {
      'variation_id': item.variation.id,
      'quantity': item.quantity,
      'modifiers': item.selectedModifiers.map((m) => m.id).toList(),
    }).toList();
  }
}
