import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final authService = AuthService();
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      final isLoggedIn = await authService.isLoggedIn();
      
      if (isLoggedIn) {
        final role = await authService.getUserRole();
        if (role == 'admin') {
          Navigator.of(context).pushReplacementNamed('/admin');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withAlpha(200),
                ],
              ),
            ),
          ),
          // Animated decorative circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(15),
                borderRadius: BorderRadius.circular(125),
              ),
            ),
          ),
          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo container with shadow
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 30,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🍲',
                          style: TextStyle(fontSize: 70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // App name with letter spacing
                    const Text(
                      'ALIYA DIVANI',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tagline
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(180),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Food Delivery Premium',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 12,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(180),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom progress indicator
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white.withAlpha(200)),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Memuat...',
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
