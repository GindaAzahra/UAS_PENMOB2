import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_service.dart';
import 'supabase_service.dart';

class OrderModel {
  final String id;
  final String userId;
  final int? restaurantId;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discountAmount;
  final double total;
  final String status;
  final String deliveryAddress;
  final DateTime orderedAt;
  final Map<String, dynamic>? metadata;

  OrderModel({
    required this.id,
    required this.userId,
    this.restaurantId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.discountAmount,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.orderedAt,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'items': items,
      'subtotal': subtotal,
      'tax': tax,
      'shipping_cost': shippingCost,
      'discount_amount': discountAmount,
      'total': total,
      'status': status,
      'delivery_address': deliveryAddress,
      'date': date, // Generate dari orderedAt
      'ordered_at': orderedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Get formatted date string
  String get date {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return '${orderedAt.day} ${months[orderedAt.month - 1]} ${orderedAt.year}';
  }

  /// Get formatted items for display
  String get itemsDisplay {
    if (items.isEmpty) return 'No items';
    return items.map((item) {
      final qty = item['quantity'] ?? item['qty'] ?? 1;
      final name = item['name'] ?? 'Item';
      return '$name x$qty';
    }).join(', ');
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    // Parse ordered_at
    final orderedAt = DateTime.tryParse(map['ordered_at'] ?? '') ?? DateTime.now();
    
    // Generate date string dari ordered_at jika tidak ada
    String dateStr = map['date'] ?? '';
    if (dateStr.isEmpty) {
      final months = ['January', 'February', 'March', 'April', 'May', 'June', 
                      'July', 'August', 'September', 'October', 'November', 'December'];
      dateStr = '${orderedAt.day} ${months[orderedAt.month - 1]} ${orderedAt.year}';
    }

    // Parse items - handle berbagai format
    List<Map<String, dynamic>> items = [];
    try {
      final rawItems = map['items'] ?? [];
      if (rawItems is List) {
        items = rawItems.map((item) {
          if (item is Map<String, dynamic>) {
            return {
              'name': item['name'] ?? 'Item',
              'quantity': item['quantity'] ?? item['qty'] ?? 1,
              'price': item['price'] ?? 0,
              'image': item['image'] ?? '',
            };
          }
          return {'name': 'Item', 'quantity': 1, 'price': 0, 'image': ''};
        }).toList();
      }
    } catch (e) {
      print('⚠️ [OrderModel] Error parsing items: $e');
      items = [];
    }

    return OrderModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      restaurantId: map['restaurant_id'],
      items: items,
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      shippingCost: (map['shipping_cost'] ?? 0).toDouble(),
      discountAmount: (map['discount_amount'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      deliveryAddress: map['delivery_address'] ?? '',
      orderedAt: orderedAt,
      metadata: map['metadata'],
    );
  }
}

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  final List<OrderModel> _orders = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  factory OrderService() {
    return _instance;
  }

  OrderService._internal();

  /// Load orders dari Supabase untuk user yang login
  Future<void> loadOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = SupabaseService.getUserId();
      print('📦 [OrderService] Loading orders for user: $userId');

      if (userId == null) {
        print('❌ [OrderService] No user logged in');
        _orders.clear();
        _isLoading = false;
        notifyListeners();
        return;
      }

      // IMPORTANT: Keep currently cached orders (newly created orders in this session)
      final List<OrderModel> inMemoryOrders = List.from(_orders);
      final Set<String> inMemoryIds = inMemoryOrders.map((o) => o.id).toSet();
      print('📦 [OrderService] In-memory orders BEFORE load: ${inMemoryIds.toList()}');
      print('📦 [OrderService] In-memory orders details: ${inMemoryOrders.map((o) => '${o.id}(${o.status})').toList()}');

      // Try load from Supabase
      try {
        final response = await SupabaseService.client
            .from('orders')
            .select()
            .eq('user_id', userId)
            .order('ordered_at', ascending: false);

        print('📦 [OrderService] Response from Supabase: $response');

        final List<OrderModel> supabaseOrders = [];
        for (var data in response) {
          supabaseOrders.add(OrderModel.fromMap(data));
        }

        // Get IDs from Supabase
        final Set<String> supabaseIds = supabaseOrders.map((o) => o.id).toSet();
        
        // Find pending orders: Orders in memory but NOT yet in Supabase
        // These are newly created orders that haven't synced yet
        final List<OrderModel> pendingOrders = inMemoryOrders
            .where((o) => !supabaseIds.contains(o.id))
            .toList();

        print('📦 [OrderService] Supabase orders (${supabaseOrders.length}): ${supabaseIds.toList()}');
        print('📦 [OrderService] Pending orders in memory (${pendingOrders.length}): ${pendingOrders.map((o) => '${o.id}(${o.status})').toList()}');

        // Merge: Supabase orders + pending local orders
        _orders.clear();
        _orders.addAll(supabaseOrders);
        _orders.addAll(pendingOrders);

        // Re-sort by date (newest first)
        _orders.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));

        print('📦 [OrderService] After merge - Total orders: ${_orders.length} (${supabaseOrders.length} from Supabase + ${pendingOrders.length} pending)');
        print('📦 [OrderService] Final order IDs: ${_orders.map((o) => '${o.id}(${o.status})').toList()}');
      } catch (e) {
        print('⚠️ [OrderService] Could not load from Supabase: $e');
        print('📦 [OrderService] Keeping in-memory orders (${inMemoryOrders.length})');
        // Keep in-memory orders if Supabase fails
        _orders.clear();
        _orders.addAll(inMemoryOrders);
      }
    } catch (e) {
      print('❌ [OrderService] Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load orders dari localStorage (deprecated - not reliable on web)
  Future<void> _loadOrdersFromLocalStorage(String userId) async {
    // For web, SharedPreferences is unreliable
    // We rely on in-memory storage for current session
    // In future, we can use IndexedDB or similar web-native storage
    print('💾 [OrderService] localStorage skipped for web platform');
  }

  /// Save orders to localStorage (deprecated - not reliable on web)
  Future<void> _saveOrdersToLocalStorage(String userId) async {
    // For web, SharedPreferences is unreliable
    // Orders are kept in memory during session
    // Supabase is the persistent backend
    print('💾 [OrderService] localStorage skipped for web platform');
  }

  List<OrderModel> get orders => _orders;

  List<Map<String, dynamic>> get ordersAsMap {
    return _orders.map((order) => order.toMap()).toList();
  }

  /// Create order dan simpan ke Supabase
  Future<OrderModel?> createOrderFromCart({
    required CartService cartService,
    required String deliveryAddress,
    int? restaurantId,
    String status = 'pending',
  }) async {
    try {
      final userId = SupabaseService.getUserId();
      if (userId == null) {
        print('❌ [OrderService] Cannot create order: user not logged in');
        return null;
      }

      print('📦 [OrderService] ========== CREATING NEW ORDER ==========');
      print('📦 [OrderService] UserId: $userId');
      print('📦 [OrderService] Status will be: $status');

      final checkoutData = cartService.getCheckoutData();
      print('📦 [OrderService] Checkout data: $checkoutData');

      if (checkoutData.isEmpty) {
        print('❌ [OrderService] Checkout data is empty!');
        return null;
      }

      final subtotal = (checkoutData['subtotal'] as num).toDouble();
      final tax = (checkoutData['tax'] as num).toDouble();
      final deliveryFee = (checkoutData['deliveryFee'] as num).toDouble();
      final discountAmount = (checkoutData['discount'] ?? 0) as num;
      final total = (checkoutData['total'] as num).toDouble();

      // Format items sebagai list of maps
      final items = (checkoutData['items'] as List)
          .map((item) => {
                'name': item['name'],
                'quantity': item['quantity'],
                'price': item['price'],
                'image': item['image'],
              })
          .toList();

      print('📦 [OrderService] Formatted items: $items');

      final orderId = const Uuid().v4(); // Generate UUID
      final now = DateTime.now();

      print('📦 [OrderService] Generated orderId: $orderId');
      print('📦 [OrderService] Order timestamp: ${now.toIso8601String()}');

      final order = OrderModel(
        id: orderId,
        userId: userId,
        restaurantId: restaurantId,
        items: items.cast<Map<String, dynamic>>(),
        subtotal: subtotal,
        tax: tax,
        shippingCost: deliveryFee,
        discountAmount: discountAmount.toDouble(),
        total: total,
        status: status,
        deliveryAddress: deliveryAddress,
        orderedAt: now,
        metadata: {
          'payment_method': 'online',
          'notes': '',
        },
      );

      print('📦 [OrderService] OrderModel created successfully: ${order.id}');

      // Save ke in-memory DULU (ini source of truth selama session)
      print('📦 [OrderService] Adding order to in-memory list...');
      _orders.insert(0, order);
      print('✅ [OrderService] Order added to memory at position 0');
      print('✅ [OrderService] Total orders in memory NOW: ${_orders.length}');
      print('✅ [OrderService] Memory order IDs: ${_orders.map((o) => o.id).toList()}');

      // Notify listeners IMMEDIATELY so UI updates
      print('📦 [OrderService] Calling notifyListeners()...');
      notifyListeners();
      print('✅ [OrderService] notifyListeners() called');

      // Try save ke Supabase (async, non-blocking)
      // If successful, great. If not, order still exists in memory
      try {
        // Create map untuk insert
        final insertData = {
          'id': orderId,
          'user_id': userId,
          'items': items,
          'subtotal': subtotal,
          'tax': tax,
          'shipping_cost': deliveryFee,
          'discount_amount': discountAmount,
          'total': total,
          'status': status,
          'delivery_address': deliveryAddress,
          'ordered_at': now.toIso8601String(),
          'metadata': {
            'payment_method': 'online',
            'notes': '',
          },
        };
        
        // Add restaurant_id hanya jika valid
        if (restaurantId != null && restaurantId > 0) {
          insertData['restaurant_id'] = restaurantId;
        }

        print('📦 [OrderService] Inserting to Supabase (async)...');
        
        final response = await SupabaseService.client.from('orders').insert(insertData).select();
        
        print('✅ [OrderService] Order synced to Supabase: $orderId');
      } catch (e) {
        print('⚠️ [OrderService] Supabase sync failed: $e');
        print('✅ [OrderService] But order is safe in memory! (${_orders.length} total)');
      }

      print('📦 [OrderService] ========== ORDER CREATION COMPLETE ==========');
      return order;
    } catch (e) {
      print('❌ [OrderService] ERROR creating order: $e');
      print('❌ [OrderService] Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Update order status di Supabase
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        final oldOrder = _orders[index];
        final updatedOrder = OrderModel(
          id: oldOrder.id,
          userId: oldOrder.userId,
          restaurantId: oldOrder.restaurantId,
          items: oldOrder.items,
          subtotal: oldOrder.subtotal,
          tax: oldOrder.tax,
          shippingCost: oldOrder.shippingCost,
          discountAmount: oldOrder.discountAmount,
          total: oldOrder.total,
          status: newStatus,
          deliveryAddress: oldOrder.deliveryAddress,
          orderedAt: oldOrder.orderedAt,
          metadata: oldOrder.metadata,
        );
        _orders[index] = updatedOrder;

        // Update di Supabase
        try {
          await SupabaseService.client
              .from('orders')
              .update({'status': newStatus})
              .eq('id', orderId);

          print('✅ [OrderService] Order status updated in Supabase: $orderId -> $newStatus');
        } catch (e) {
          print('⚠️ [OrderService] Could not update status in Supabase: $e');
        }

        notifyListeners();
      }
    } catch (e) {
      print('❌ [OrderService] Error updating order status: $e');
    }
  }

  /// Get latest order
  OrderModel? get latestOrder {
    if (_orders.isEmpty) return null;
    return _orders.first;
  }

  /// Check if there are any orders
  bool get hasOrders => _orders.isNotEmpty;

  /// Clear all orders (for testing)
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}
