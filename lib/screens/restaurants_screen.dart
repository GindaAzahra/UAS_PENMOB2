import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cards.dart';
import 'restaurant_detail_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  String _searchQuery = '';

  List<Map<String, dynamic>> get filteredRestaurants {
    if (_searchQuery.isEmpty) {
      return dummyRestaurants;
    }
    return dummyRestaurants
        .where((restaurant) =>
            restaurant['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Restoran',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari restoran',
                prefixIcon: const Icon(Icons.search, color: darkGrayColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: lightGrayColor),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = filteredRestaurants[index];
                return RestaurantCard(
                  name: restaurant['name'],
                  rating: restaurant['rating'],
                  reviews: restaurant['reviews'],
                  imageUrl: restaurant['image'],
                  description: restaurant['description'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
