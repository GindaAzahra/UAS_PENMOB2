import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cards.dart';
import '../widgets/form_widgets.dart' as form_widgets;
import '../widgets/advanced_widgets.dart';
import '../widgets/premium_widgets.dart';
import '../services/auth_service.dart';
import '../services/comment_service.dart';
import '../services/cart_service.dart';
import 'food_detail_screen.dart';
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
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _commentService = CommentService();
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

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    _loadUserName();
    setState(() => _isRefreshing = false);
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          pinned: true,
          expandedHeight: 90,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, Color(0xFF00A86B)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Halo, ${userName ?? "Pelanggan"}! 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pesan makanan favorit Anda sekarang',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
                }).toList(),
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
                      }).toList(),
                      // Product comments as testimonials
                      ..._commentService.getAllProductComments().take(4).map((comment) {
                        return TestimonialCard(
                          name: comment.userName,
                          rating: 5.0,
                          image: comment.userImage,
                          comment: comment.content,
                          date: comment.createdAt.toString().split(' ')[0],
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const Text(
                  'Makanan Populer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
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
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
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
