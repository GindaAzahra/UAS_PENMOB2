class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String address;
  final String city;
  final List<String> favoriteRestaurants;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.address,
    required this.city,
    this.favoriteRestaurants = const [],
  });
}

class Order {
  final String id;
  final List<dynamic> items;
  final double totalPrice;
  final String status;
  final DateTime orderDate;
  final String deliveryAddress;
  final String restaurantName;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    required this.restaurantName,
  });
}
