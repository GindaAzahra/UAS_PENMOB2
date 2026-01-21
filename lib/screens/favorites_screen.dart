import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Map<String, dynamic>> favorites = [
    {
      'id': 1,
      'name': 'Nasi Goreng Spesial',
      'category': 'Nasi',
      'price': 25000.0,
      'rating': 4.8,
      'image': '🍚',
    },
    {
      'id': 2,
      'name': 'Satay Chicken',
      'category': 'Meat',
      'price': 28000.0,
      'rating': 4.9,
      'image': '🍗',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: const Text(
          'Favorit Saya',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('❤️', style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum Ada Favorit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan makanan atau restoran favorit Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: darkGrayColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final fav = favorites[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              fav['image'],
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fav['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  fav['category'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: darkGrayColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp ${fav['price'].toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          size: 14,
                                          color: accentColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          fav['rating'].toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                favorites.removeAt(index);
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
