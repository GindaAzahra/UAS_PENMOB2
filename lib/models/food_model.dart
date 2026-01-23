class Food {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String description;
  final List<String> ingredients;

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      reviews: json['reviews'] is int ? json['reviews'] as int : int.tryParse(json['reviews']?.toString() ?? '') ?? 0,
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      description: json['description'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class Restaurant {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String description;
  final List<Food> foods;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.foods,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final foodsJson = json['foods'] as List<dynamic>? ?? [];
    final foods = foodsJson.map((f) => Food.fromJson(f as Map<String, dynamic>)).toList();

    return Restaurant(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      reviews: json['reviews'] is int ? json['reviews'] as int : int.tryParse(json['reviews']?.toString() ?? '') ?? 0,
      description: json['description'] ?? '',
      foods: foods,
    );
  }
}

class CartItem {
  final Food food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });

  double get total => food.price * quantity;
}
