import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cards.dart';
import '../widgets/advanced_widgets.dart';
import 'food_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;
  String selectedSortBy = 'rating';
  RangeValues priceRange = const RangeValues(0, 100000);
  double selectedRating = 0;
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredResults {
    List<Map<String, dynamic>> results = dummyFoods;

    // Filter by search query
    if (searchController.text.isNotEmpty) {
      results = results
          .where((food) => food['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    // Filter by price range
    results = results
        .where((food) =>
            food['price'] >= priceRange.start &&
            food['price'] <= priceRange.end)
        .toList();

    // Filter by rating
    if (selectedRating > 0) {
      results = results
          .where((food) => food['rating'] >= selectedRating)
          .toList();
    }

    // Sort
    if (selectedSortBy == 'rating') {
      results.sort((a, b) => b['rating'].compareTo(a['rating']));
    } else if (selectedSortBy == 'price_low') {
      results.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (selectedSortBy == 'price_high') {
      results.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (selectedSortBy == 'newest') {
      results = results.reversed.toList();
    }

    return results;
  }

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
          'Cari Makanan',
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
            child: Column(
              children: [
                // Search field
                Container(
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
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Cari makanan...',
                      hintStyle: const TextStyle(color: darkGrayColor),
                      prefixIcon:
                          const Icon(Icons.search, color: darkGrayColor),
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                searchController.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.close,
                                  color: darkGrayColor),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter toggle button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hasil: ${filteredResults.length} item',
                      style: const TextStyle(
                        fontSize: 12,
                        color: darkGrayColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => showFilters = !showFilters),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: showFilters ? primaryColor : lightGrayColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tune,
                              size: 16,
                              color: showFilters ? Colors.white : textColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: showFilters ? Colors.white : textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filters
          if (showFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Urutkan Berdasarkan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Rating',
                        value: 'rating',
                        selected: selectedSortBy == 'rating',
                        onTap: () =>
                            setState(() => selectedSortBy = 'rating'),
                      ),
                      _FilterChip(
                        label: 'Harga Rendah',
                        value: 'price_low',
                        selected: selectedSortBy == 'price_low',
                        onTap: () =>
                            setState(() => selectedSortBy = 'price_low'),
                      ),
                      _FilterChip(
                        label: 'Harga Tinggi',
                        value: 'price_high',
                        selected: selectedSortBy == 'price_high',
                        onTap: () =>
                            setState(() => selectedSortBy = 'price_high'),
                      ),
                      _FilterChip(
                        label: 'Terbaru',
                        value: 'newest',
                        selected: selectedSortBy == 'newest',
                        onTap: () =>
                            setState(() => selectedSortBy = 'newest'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Harga',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: priceRange,
                    min: 0,
                    max: 100000,
                    divisions: 10,
                    labels: RangeLabels(
                      'Rp ${priceRange.start.toInt()}',
                      'Rp ${priceRange.end.toInt()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() => priceRange = values);
                    },
                    activeColor: primaryColor,
                    inactiveColor: lightGrayColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rating Minimum',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final rating = (index + 1).toDouble();
                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedRating = selectedRating == rating ? 0 : rating;
                        }),
                        child: Icon(
                          Icons.star_rounded,
                          size: 28,
                          color: index < selectedRating
                              ? accentColor
                              : lightGrayColor,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          // Results
          Expanded(
            child: filteredResults.isEmpty
                ? EmptyStateWidget(
                    emoji: '🔍',
                    title: 'Tidak Ada Hasil',
                    subtitle:
                        'Coba ubah pencarian atau filter Anda',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final food = filteredResults[index];
                      return FoodCard(
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
                              builder: (context) =>
                                  FoodDetailScreen(food: food),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primaryColor : lightGrayColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }
}
