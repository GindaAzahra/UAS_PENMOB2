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
