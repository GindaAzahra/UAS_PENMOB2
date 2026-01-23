import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/food_model.dart';
import '../models/promo_model.dart';

class EnhancedCartService {
  static final EnhancedCartService _instance = EnhancedCartService._internal();

  factory EnhancedCartService() {
    return _instance;
  }

  EnhancedCartService._internal();

  final List<CartItem> _items = [];
  PromoCode? _appliedPromo;
  late SharedPreferences _prefs;

  List<CartItem> get items => _items;
  PromoCode? get appliedPromo => _appliedPromo;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFromStorage();
  }

  void addItem(Food food, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.food.id == food.id);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(food: food, quantity: quantity));
    }

    _saveToStorage();
  }

  void removeItem(int foodId) {
    _items.removeWhere((item) => item.food.id == foodId);
    _saveToStorage();
  }

  void updateQuantity(int foodId, int quantity) {
    final index = _items.indexWhere((item) => item.food.id == foodId);
    if (index != -1) {
      if (quantity <= 0) {
        removeItem(foodId);
      } else {
        _items[index].quantity = quantity;
        _saveToStorage();
      }
    }
  }

  void clearCart() {
    _items.clear();
    _appliedPromo = null;
    _saveToStorage();
  }

  int getTotalItems() {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double getSubtotal() {
    return _items.fold(0, (sum, item) => sum + (item.food.price * item.quantity));
  }

  double getTax() {
    return getSubtotal() * 0.1; // 10% tax
  }

  double getShippingCost() {
    if (getSubtotal() < 50000) {
      return 10000; // Rp 10,000 for orders below 50,000
    }
    return 0; // Free shipping for orders 50,000+
  }

  double getDiscountAmount() {
    if (_appliedPromo == null) return 0;
    if (getSubtotal() < _appliedPromo!.minOrderAmount) return 0;
    return getSubtotal() * (_appliedPromo!.discountPercentage / 100);
  }

  double getTotal() {
    final subtotal = getSubtotal();
    final tax = getTax();
    final shipping = getShippingCost();
    final discount = getDiscountAmount();
    return subtotal + tax + shipping - discount;
  }

  CartSummary getCartSummary() {
    return CartSummary(
      subtotal: getSubtotal(),
      tax: getTax(),
      shippingCost: getShippingCost(),
      discountAmount: getDiscountAmount(),
      total: getTotal(),
      appliedPromo: _appliedPromo,
    );
  }

  bool applyPromoCode(String code) {
    // Available promo codes
    final promoCodes = [
      PromoCode(
        code: 'WELCOME20',
        discountPercentage: 20,
        minOrderAmount: 30000,
        description: 'Welcome discount 20% off',
      ),
      PromoCode(
        code: 'SAVE30',
        discountPercentage: 30,
        minOrderAmount: 50000,
        description: 'Save up to 30%',
      ),
      PromoCode(
        code: 'DELIVERY10',
        discountPercentage: 10,
        minOrderAmount: 20000,
        description: 'Free delivery + 10% off',
      ),
      PromoCode(
        code: 'ALIYA25',
        discountPercentage: 25,
        minOrderAmount: 75000,
        description: 'Aliya special offer 25% off',
      ),
    ];

    final promo = promoCodes.firstWhere(
      (p) => p.code.toUpperCase() == code.toUpperCase(),
      orElse: () => PromoCode(
        code: '',
        discountPercentage: 0,
        minOrderAmount: 0,
        description: '',
        isActive: false,
      ),
    );

    if (promo.code.isEmpty) {
      return false; // Invalid promo code
    }

    if (getSubtotal() < promo.minOrderAmount) {
      return false; // Minimum order not met
    }

    _appliedPromo = promo;
    _saveToStorage();
    return true;
  }

  void removePromoCode() {
    _appliedPromo = null;
    _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    try {
      final itemsJson = jsonEncode(
        _items.map((item) => {
          'food': {
            'id': item.food.id,
            'name': item.food.name,
            'category': item.food.category,
            'price': item.food.price,
            'rating': item.food.rating,
            'reviews': item.food.reviews,
            'description': item.food.description,
            'imageUrl': item.food.imageUrl,
            'ingredients': item.food.ingredients,
          },
          'quantity': item.quantity,
        }).toList(),
      );

      await _prefs.setString('cart_items', itemsJson);

      if (_appliedPromo != null) {
        await _prefs.setString('applied_promo', jsonEncode(_appliedPromo!.toJson()));
      } else {
        await _prefs.remove('applied_promo');
      }
    } catch (e) {
      // Error saving cart
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final itemsJson = _prefs.getString('cart_items');
      if (itemsJson != null) {
        final List<dynamic> decoded = jsonDecode(itemsJson);
        _items.clear();
        for (var item in decoded) {
          final food = Food(
            id: item['food']['id'],
            name: item['food']['name'],
            category: item['food']['category'],
            price: (item['food']['price'] as num).toDouble(),
            rating: (item['food']['rating'] as num).toDouble(),
            reviews: item['food']['reviews'] as int,
            description: item['food']['description'] ?? '',
            imageUrl: item['food']['imageUrl'] ?? '',
            ingredients: List<String>.from(item['food']['ingredients'] ?? []),
          );
          _items.add(CartItem(food: food, quantity: item['quantity'] as int));
        }
      }

      final promoJson = _prefs.getString('applied_promo');
      if (promoJson != null) {
        final decoded = jsonDecode(promoJson);
        _appliedPromo = PromoCode.fromJson(decoded);
      }
    } catch (e) {
      // Error loading cart
    }
  }
}
