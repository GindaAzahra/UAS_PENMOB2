import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';
import '../widgets/form_widgets.dart';
import '../widgets/comment_section.dart';
import '../services/comment_service.dart';
import '../services/cart_service.dart';

class FoodDetailScreen extends StatefulWidget {
  final Map<String, dynamic> food;

  const FoodDetailScreen({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;
  late CommentService _commentService;
  late String _productId;
  final CartService _cartService = CartService();
  final TextEditingController _notesController = TextEditingController();
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _commentService = CommentService();
    _productId = 'product_${widget.food['name']}';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: primaryColor),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: lightGrayColor,
                child: Image.network(
                  food['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: lightGrayColor,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 80, color: darkGrayColor),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              food['category'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: darkGrayColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RatingBar(
                    rating: food['rating'],
                    reviews: food['reviews'],
                    size: 16,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Deskripsi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: darkGrayColor,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bahan-bahan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List<Widget>.from(
                      food['ingredients'].map(
                        (ingredient) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ingredient,
                            style: const TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Jumlah',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Catatan (Opsional)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Tidak pedas, tanpa bawang, dll',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: lightGrayColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Harga',
                            style: TextStyle(
                              fontSize: 12,
                              color: darkGrayColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${(food['price'] * quantity).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: PrimaryButton(
                            label: 'Tambah ke Keranjang',
                            icon: Icons.shopping_cart_outlined,
                            isLoading: _isAddingToCart,
                            onPressed: _isAddingToCart ? () {} : () async {
                              setState(() => _isAddingToCart = true);
                              HapticFeedback.mediumImpact();
                              
                              _cartService.addItem(
                                food,
                                quantity: quantity,
                                notes: _notesController.text,
                              );
                              
                              await Future.delayed(const Duration(milliseconds: 500));
                              
                              if (mounted) {
                                setState(() => _isAddingToCart = false);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.white, size: 22),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${quantity}x ${food['name']}',
                                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                              ),
                                              const Text(
                                                'Ditambahkan ke keranjang',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: successColor,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    action: SnackBarAction(
                                      label: 'LIHAT KERANJANG',
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/cart');
                                      },
                                    ),
                                  ),
                                );
                                
                                // Reset form
                                setState(() {
                                  quantity = 1;
                                  _notesController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Reviews and Comments Section
                  const Text(
                    '💬 Ulasan & Komentar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CommentSection(
                    itemId: _productId,
                    initialComments: _commentService.getComments(_productId),
                    onCommentAdded: (comment) {
                      setState(() {
                        _commentService.addComment(_productId, comment);
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
