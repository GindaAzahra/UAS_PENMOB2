import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/advanced_widgets.dart';
import '../widgets/buttons.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const DeliveryTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  State<DeliveryTrackingScreen> createState() =>
      _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  late PageController _pageController;
  int currentStep = 3; // 1: Confirmed, 2: Preparing, 3: On the way, 4: Delivered

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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: const Text(
          'Lacak Pesanan',
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
          children: [
            // Order ID
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
                  const Text(
                    'ID Pesanan',
                    style: TextStyle(fontSize: 12, color: darkGrayColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.order['id'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Status Timeline
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
              padding: const EdgeInsets.all(20),
              child: StepIndicator(
                currentStep: currentStep,
                totalSteps: 4,
                labels: ['Dikonfirmasi', 'Disiapkan', 'Dikirim', 'Tiba'],
              ),
            ),
            const SizedBox(height: 24),
            // Delivery Timeline Details
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
              child: Column(
                children: [
                  _TimelineItem(
                    title: 'Pesanan Dikonfirmasi',
                    time: '14:30',
                    description: 'Pesanan Anda telah dikonfirmasi',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _TimelineItem(
                    title: 'Sedang Disiapkan',
                    time: '14:45',
                    description: 'Restoran sedang menyiapkan pesanan Anda',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _TimelineItem(
                    title: 'Dalam Pengiriman',
                    time: '15:10',
                    description: 'Pesanan sedang dalam perjalanan ke lokasi Anda',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _TimelineItem(
                    title: 'Tiba di Tujuan',
                    time: '-',
                    description: 'Pesanan akan tiba dalam 10-15 menit',
                    isCompleted: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Driver Info
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
                  const Text(
                    'Informasi Kurir',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text('👤', style: TextStyle(fontSize: 30)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Budi Santoso',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 14, color: accentColor),
                                const SizedBox(width: 4),
                                const Text(
                                  '4.8',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.call, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Location
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
                  const Text(
                    'Lokasi Pengiriman',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: lightGrayColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              size: 40, color: primaryColor),
                          SizedBox(height: 8),
                          Text('📍 Peta Google Maps'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jl. Merdeka No. 123, Jakarta Selatan',
                    style: TextStyle(
                      fontSize: 12,
                      color: darkGrayColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Hubungi Kurir',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menghubungi kurir...'),
                    backgroundColor: successColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.time,
    required this.description,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted ? successColor : lightGrayColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: isCompleted
                        ? const Center(
                            child: Icon(Icons.check,
                                color: Colors.white, size: 14),
                          )
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 60,
                      color: lightGrayColor,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: darkGrayColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: darkGrayColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
