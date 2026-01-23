import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  final List<CartItemModel> _items = [];

  String _promoCode = '';
  double _discountAmount = 0;
  bool _isPromoApplied = false;

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  List<CartItemModel> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.total);

  double get totalPrice => total;

  // Tax calculation (10%)
  double get tax => subtotal * 0.10;

  // Free delivery for orders above 50k
  double get deliveryFee => subtotal >= 50000 ? 0 : 15000;

  // Promo getters
  String get promoCode => _promoCode;
  bool get isPromoApplied => _isPromoApplied;
  double get discountAmount => _discountAmount;

  // Final total
  double get total => subtotal + tax + deliveryFee - _discountAmount;

  void addItem(
    Map<String, dynamic> food, {
    int quantity = 1,
    String notes = '',
  }) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.foodId == food['id'],
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += quantity;
      if (notes.isNotEmpty) {
        _items[existingItemIndex].notes = notes;
      }
    } else {
      _items.add(
        CartItemModel(
          foodId: food['id'],
          foodName: food['name'],
          price: (food['price'] as num).toDouble(),
          image: food['image'],
          quantity: quantity,
          notes: notes,
        ),
      );
    }
    _validatePromo();
    notifyListeners();
  }

  void removeItem(int foodId) {
    _items.removeWhere((item) => item.foodId == foodId);
    _validatePromo();
    notifyListeners();
  }

  void updateQuantity(int foodId, int quantity) {
    try {
      final item = _items.firstWhere((item) => item.foodId == foodId);
      if (quantity > 0) {
        item.quantity = quantity;
        _validatePromo();
        notifyListeners();
      } else {
        removeItem(foodId);
      }
    } catch (e) {
      // Item not found
    }
  }

  void updateNotes(int foodId, String notes) {
    try {
      final item = _items.firstWhere((item) => item.foodId == foodId);
      item.notes = notes;
      notifyListeners();
    } catch (e) {
      // Item not found
    }
  }

  // Promo code management
  bool applyPromo(String code) {
    final upperCode = code.toUpperCase().trim();

    if (upperCode.isEmpty) {
      return false;
    }

    // Define available promos
    final promos = {
      'WELCOME20': 0.20, // 20% discount
      'ALIYA15': 0.15, // 15% discount
      'FOOD10': 0.10, // 10% discount
      'FREESHIP': 0.0, // Free delivery
    };

    if (promos.containsKey(upperCode)) {
      _promoCode = upperCode;

      if (upperCode == 'FREESHIP') {
        _discountAmount = deliveryFee;
      } else {
        _discountAmount = subtotal * promos[upperCode]!;
      }

      _isPromoApplied = true;
      notifyListeners();
      return true;
    }

    return false;
  }

  void _validatePromo() {
    if (_isPromoApplied) {
      applyPromo(_promoCode); // Recalculate discount
    }
  }

  void removePromo() {
    _promoCode = '';
    _discountAmount = 0;
    _isPromoApplied = false;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    removePromo();
    notifyListeners();
  }

  bool hasItems() => _items.isNotEmpty;

  // Get checkout summary
  Map<String, dynamic> getCheckoutData() {
    return {
      'items': _items
          .map(
            (item) => {
              'id': item.foodId,
              'name': item.foodName,
              'price': item.price,
              'quantity': item.quantity,
              'notes': item.notes,
              'image': item.image,
              'total': item.total,
            },
          )
          .toList(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'discount': _discountAmount,
      'promoCode': _promoCode,
      'total': total,
      'itemCount': itemCount,
    };
  }
}

class CartItemModel {
  final int foodId;
  final String foodName;
  final double price;
  final String image;
  int quantity;
  String notes;

  CartItemModel({
    required this.foodId,
    required this.foodName,
    required this.price,
    required this.image,
    required this.quantity,
    this.notes = '',
  });

  double get total => price * quantity;
}
