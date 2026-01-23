import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cards.dart';
import '../widgets/form_widgets.dart' as form_widgets;
import '../widgets/advanced_widgets.dart';
import '../widgets/premium_widgets.dart';
import '../services/auth_service.dart';
import '../services/comment_service.dart';
import '../services/cart_service.dart';
import '../services/supabase_service.dart';
import '../models/index.dart' as models;
import 'enhanced_cart_screen.dart';
import 'profile_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? userName;
  late CommentService _commentService;
  final CartService _cartService = CartService();
  late Future<List<models.Restaurant>> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _commentService = CommentService();
    _restaurantsFuture = SupabaseService.getRestaurants();
    // Listen for comment changes so product comments appear automatically
    _commentService.addListener(_onCommentsUpdated);
    // Listen for cart changes
    _cartService.addListener(_onCartUpdated);
  }

  void _onCommentsUpdated() {
    // Force rebuild to include latest product comments
    setState(() {});
  }

  void _onCartUpdated() {
    // Force rebuild to update cart badge
    setState(() {});
  }

  @override
  void dispose() {
    _commentService.removeListener(_onCommentsUpdated);
    _cartService.removeListener(_onCartUpdated);
    super.dispose();
  }

  void _loadUserName() async {
    final authService = AuthService();
    final name = await authService.getUserName();
    setState(() {
      userName = name;
    });
  }

  List<Map<String, dynamic>> get filteredFoods {
    final filtered = dummyFoods.where((food) {
      if (_searchQuery.isEmpty) return true;
      return food['name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    return filtered;
  }

  List<Map<String, dynamic>> get topRatedFoods {
    return dummyFoods.take(5).map((food) {
      return {
        ...food,
        'badge': '⭐ Top Rated',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _selectedIndex == 0
          ? _buildHomeTab()
          : _selectedIndex == 1
              ? const EnhancedCartScreen()
              : _selectedIndex == 2
                  ? const OrdersScreen()
                  : const ProfileScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, -6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: primaryColor,
                unselectedItemColor: darkGrayColor,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0 ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home_outlined, size: 24),
                    ),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home, size: 24),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1 ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 24),
                          if (_cartService.items.isNotEmpty)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: errorColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                child: Text(
                                  _cartService.totalItems.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart, size: 24),
                          if (_cartService.items.isNotEmpty)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: errorColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                child: Text(
                                  _cartService.totalItems.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    label: 'Keranjang',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 2 ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.receipt_long_outlined, size: 24),
                    ),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.receipt_long, size: 24),
                    ),
                    label: 'Pesanan',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 3 ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_outline, size: 24),
                    ),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, size: 24),
                    ),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          pinned: true,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.8), const Color(0xFF00C77B)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, ${userName ?? "Pelanggan"}! 👋',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Mau makan apa hari ini?',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () async {
                  final authService = AuthService();
                  await authService.logout();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                child: const Tooltip(
                  message: 'Logout',
                  child: Icon(Icons.logout, color: Colors.white, size: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
                child: Stack(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                    if (_cartService.items.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: errorColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            _cartService.totalItems.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                form_widgets.SearchBar(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Loyalty Card
                LoyaltyCard(
                  currentPoints: loyaltyProgram['currentPoints'],
                  pointsNeeded: loyaltyProgram['pointsToNextTier'],
                  memberLevel: loyaltyProgram['memberLevel'],
                  nextTier: loyaltyProgram['nextTier'],
                ),
                const SizedBox(height: 24),
                // Special Deals Section
                CategorySectionHeader(
                  title: '🎁 Penawaran Spesial',
                  subtitle: 'Dapatkan diskon eksklusif hari ini',
                ),
                ...specialDeals.map((deal) {
                  return SpecialDealCard(
                    title: deal['title'],
                    description: deal['description'],
                    discount: deal['discount'],
                    icon: deal['icon'],
                    validUntil: deal['validUntil'],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${deal['title']} ditambahkan ke keranjang!'),
                          backgroundColor: primaryColor,
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 24),
                // Promo Banner
                PromoBanner(
                  title: 'Diskon Spesial',
                  subtitle: 'Pesan sekarang dan dapatkan bonus',
                  discount: '-30%',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Promo telah diterapkan!')),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Restaurants from Supabase (or local fallback)
                CategorySectionHeader(
                  title: '🏠 Restoran Terdekat',
                  subtitle: 'Pilihan tempat makan di sekitar',
                ),
                SizedBox(
                  height: 220,
                  child: FutureBuilder<List<models.Restaurant>>(
                    future: _restaurantsFuture,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text('Error: ${snap.error}'));
                      }
                      final restaurants = snap.data ?? [];
                      if (restaurants.isEmpty) {
                        return const Center(child: Text('Tidak ada restoran.'));
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder: (context, i) {
                          final r = restaurants[i];
                          return Container(
                            width: 260,
                            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: r.imageUrl.isNotEmpty
                                        ? Image.network(
                                            r.imageUrl,
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                height: 120,
                                                color: const Color(0xFFF2F2F2),
                                                child: const Center(child: CircularProgressIndicator()),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                height: 120,
                                                color: const Color(0xFFF2F2F2),
                                                child: const Center(child: Icon(Icons.image_not_supported, size: 36)),
                                              );
                                            },
                                          )
                                        : Container(height: 120, color: const Color(0xFFF2F2F2)),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(r.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 6),
                                          Expanded(
                                            child: Text(r.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.star, size: 14, color: Colors.orange),
                                                  const SizedBox(width: 4),
                                                  Text(r.rating.toString()),
                                                ],
                                              ),
                                              Text('Rp ${r.foods.isNotEmpty ? r.foods.first.price.toStringAsFixed(0) : '–'}', style: const TextStyle(fontWeight: FontWeight.w700, color: primaryColor)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemCount: restaurants.length,
                      );
                    },
                  ),
                ),
                // Top Rated Foods
                CategorySectionHeader(
                  title: '⭐ Makanan Pilihan',
                  subtitle: 'Favorit pelanggan kami',
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: topRatedFoods.map((food) {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: lightGrayColor,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      food['image'] as String,
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                            color: primaryColor,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: lightGrayColor,
                                          child: const Icon(Icons.image_not_supported, size: 40),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: TopRatedBadge(
                                      badge: food['badge'] as String,
                                      rating: food['rating'] as double,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 140,
                              child: Text(
                                food['name'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                // Testimonials Section
                CategorySectionHeader(
                  title: '💬 Apa Kata Pelanggan',
                  subtitle: 'Pengalaman mereka dengan Aliya Divani',
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Original testimonials
                      ...testimonials.map((testimonial) {
                        return TestimonialCard(
                          name: testimonial['name'],
                          rating: testimonial['rating'],
                          image: testimonial['image'],
                          comment: testimonial['comment'],
                          date: testimonial['date'],
                        );
                      }),
                      // Product comments as testimonials
                      ..._commentService.getAllProductComments().take(4).map((comment) {
                        return TestimonialCard(
                          name: comment.userName,
                          rating: 5.0,
                          image: comment.userImage,
                          comment: comment.content,
                          date: comment.createdAt.toString().split(' ')[0],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🍽️ Makanan Populer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 13,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final food = filteredFoods[index];
                return FoodCard(
                  name: food['name'],
                  category: food['category'],
                  price: food['price'],
                  rating: food['rating'],
                  reviews: food['reviews'],
                  imageUrl: food['image'],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/food_detail',
                      arguments: food,
                    );
                  },
                );
              },
              childCount: filteredFoods.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

