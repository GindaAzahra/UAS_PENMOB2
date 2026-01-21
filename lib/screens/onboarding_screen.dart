import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      title: 'Selamat Datang',
      description: 'Nikmati makanan favorit Anda dengan pengiriman cepat dan mudah',
      emoji: '👋',
      color: primaryColor,
    ),
    OnboardingData(
      title: 'Pilih Makanan',
      description: 'Pilih dari ribuan makanan lezat dari restoran terbaik',
      emoji: '🍽️',
      color: const Color(0xFF44A08D),
    ),
    OnboardingData(
      title: 'Pengiriman Cepat',
      description: 'Terima pesanan Anda dengan cepat dan aman',
      emoji: '🚴',
      color: const Color(0xFFFDB833),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          return OnboardingPage(data: onboardingData[index]);
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? primaryColor : lightGrayColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _currentPage == onboardingData.length - 1
                ? PrimaryButton(
                    label: 'Mulai',
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  )
                : Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'Lewati',
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/home');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Lanjut',
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String emoji;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.emoji,
              style: const TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                data.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                data.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
