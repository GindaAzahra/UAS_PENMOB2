import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';

class ReviewScreen extends StatefulWidget {
  final String foodName;
  final String restaurantName;

  const ReviewScreen({
    super.key,
    required this.foodName,
    required this.restaurantName,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double rating = 0;
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
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
          'Tulis Ulasan',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foodName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.restaurantName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkGrayColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Berapa rating untuk makanan ini?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
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
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = (index + 1).toDouble();
                      });
                    },
                    child: Icon(
                      Icons.star_rounded,
                      size: 40,
                      color: index < rating ? accentColor : lightGrayColor,
                    ),
                  );
                }),
              ),
            ),
            if (rating > 0)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Rating: ${rating.toInt()} dari 5',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Tulis Ulasan Anda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
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
                controller: reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Bagaimana pengalaman Anda? Tulis ulasan...',
                  hintStyle: const TextStyle(color: darkGrayColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Kirim Ulasan',
              onPressed: () {
                if (rating > 0 && reviewController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terima kasih untuk ulasan Anda!'),
                      backgroundColor: successColor,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mohon lengkapi rating dan ulasan'),
                      backgroundColor: errorColor,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
