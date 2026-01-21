import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/search_screen.dart';
import 'screens/enhanced_cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/food_detail_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/restaurants_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/loyalty_program_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'utils/constants.dart';
import 'utils/animations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aliya Divani - Food Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4ECDC4)),
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const EnhancedCartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/order_tracking': (context) => const OrderTrackingScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/restaurants': (context) => const RestaurantsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/wallet': (context) => const WalletScreen(),
        '/loyalty': (context) => const LoyaltyProgramScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
      onGenerateRoute: (settings) {
        // Search screen with arguments
        if (settings.name == '/search') {
          final args = settings.arguments as String?;
          return SlideInFromRightRoute(
            page: SearchScreen(initialQuery: args),
          );
        }
        // Food detail screen with arguments
        if (settings.name == '/food_detail') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return SlideInFromRightRoute(
              page: FoodDetailScreen(food: args),
            );
          }
        }
        // Fallback for unknown routes
        return null;
      },
    );
  }
}
