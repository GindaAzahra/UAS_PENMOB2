import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/search_screen.dart';
import 'screens/enhanced_cart_screen.dart';
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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/search') {
          final args = settings.arguments as String?;
          return SlideInFromRightRoute(
            page: SearchScreen(initialQuery: args),
          );
        }
        return null;
      },
    );
  }
}
