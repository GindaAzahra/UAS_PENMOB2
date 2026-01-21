import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/utility_widgets.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  
  const OrderTrackingScreen({super.key, this.orderId = 'ORD002'});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int currentStep = 2; // 0: Confirmed, 1: Preparing, 2: On the way, 3: Delivered

  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Pesanan Dikonfirmasi',
      'subtitle': 'Pesanan diterima dan sedang dikonfirmasi',
      'icon': '✓',
      'time': '14:30',
    },
    {
      'title': 'Sedang Disiapkan',
      'subtitle': 'Makanan sedang disiapkan di dapur',
      'icon': '👨‍🍳',
      'time': '14:35',
    },
    {
      'title': 'Dalam Pengiriman',
      'subtitle': 'Driver sedang membawa pesanan Anda',
      'icon': '🚗',
      'time': '14:50',
    },
    {
      'title': 'Pesanan Tiba',
      'subtitle': 'Terima pesanan Anda',
      'icon': '📦',
      'time': '15:15 (est)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tracking Pesanan',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order ID Card with Image
            Container(
              margin: const EdgeInsets.all(16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: lightGrayColor,
              ),
              child: Stack(
                children: [
                  Image.network(
                    dummyOrders[1]['image'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 60);
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dummyOrders[1]['id'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dummyOrders[1]['restaurant'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            StatusBadge(
                              label: dummyOrders[1]['status'],
                              type: StatusType.warning,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Timeline Progress
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(
                  steps.length,
                  (index) {
                    final step = steps[index];
                    final isCompleted = index <= currentStep;
                    final isCurrent = index == currentStep;

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isCompleted ? primaryColor : lightGrayColor,
                                    border: isCurrent
                                        ? Border.all(color: primaryColor, width: 3)
                                        : null,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: isCurrent
                                        ? [
                                            BoxShadow(
                                              color: primaryColor.withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      step['icon'],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                                if (index < steps.length - 1)
                                  Container(
                                    width: 3,
                                    height: 60,
                                    color: index < currentStep
                                        ? primaryColor
                                        : lightGrayColor,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step['title'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted ? textColor : darkGrayColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      step['subtitle'],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: darkGrayColor,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      step['time'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: primaryColor.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Driver Info
            if (currentStep >= 2) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: lightGrayColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Driver',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: lightGrayColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text('🧑‍🦱', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Andi Wijaya',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              RatingDisplay(rating: 4.9, reviews: 234, compact: true),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Panggilan akan dimulai...'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Chat dibuka...'),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: primaryColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Icon(
                                  Icons.message,
                                  color: primaryColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Order Items
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: lightGrayColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Item Pesanan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _OrderItem(
                    name: 'Satay Chicken',
                    quantity: 1,
                    price: 28000,
                  ),
                  Divider(color: lightGrayColor, height: 12),
                  _OrderItem(
                    name: 'Lumpia',
                    quantity: 2,
                    price: 12000,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Rp 52,000',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightGrayColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Membuka peta...'),
                            backgroundColor: secondaryColor,
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on, color: textColor, size: 18),
                      label: const Text(
                        'Lihat Peta',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Berbagi pesanan...'),
                            backgroundColor: primaryColor,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text(
                        'Bagikan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String name;
  final int quantity;
  final int price;

  const _OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: $quantity',
                style: const TextStyle(
                  fontSize: 10,
                  color: darkGrayColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Rp ${(price * quantity).toString()}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
