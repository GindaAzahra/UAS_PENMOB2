import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cards.dart';
import '../widgets/form_widgets.dart';
import 'food_detail_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final categories = ['Semua', 'Nasi', 'Soup', 'Meat'];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: primaryColor),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: lightGrayColor,
                child: Center(
                  child: Text(
                    restaurant['image'],
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              restaurant['description'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: darkGrayColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RatingBar(
                    rating: restaurant['rating'],
                    reviews: restaurant['reviews'],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: lightGrayColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: const [
                            Icon(Icons.location_on_outlined, color: primaryColor),
                            SizedBox(height: 4),
                            Text('Lokasi', style: TextStyle(fontSize: 12, color: darkGrayColor)),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.schedule_outlined, color: primaryColor),
                            SizedBox(height: 4),
                            Text('30 min', style: TextStyle(fontSize: 12, color: darkGrayColor)),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.local_shipping_outlined, color: primaryColor),
                            SizedBox(height: 4),
                            Text('Gratis Ongkir', style: TextStyle(fontSize: 12, color: darkGrayColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedCategory == category ? primaryColor : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _selectedCategory == category ? primaryColor : lightGrayColor,
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedCategory == category ? Colors.white : textColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final food = dummyFoods[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FoodCard(
                      name: food['name'],
                      category: food['category'],
                      price: food['price'],
                      rating: food['rating'],
                      reviews: food['reviews'],
                      imageUrl: food['image'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailScreen(food: food),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: dummyFoods.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}
