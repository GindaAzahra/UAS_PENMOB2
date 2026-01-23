import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import '../widgets/utility_widgets.dart';
import '../services/order_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final OrderModel? orderData;
  
  const OrderTrackingScreen({super.key, this.orderId = 'ORD002', this.orderData});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int currentStep = 1; // 0: Confirmed, 1: Preparing, 2: On the way, 3: Delivered
  late OrderModel _order;

  @override
  void initState() {
    super.initState();
    // Use provided orderData or find from dummyOrders
    if (widget.orderData != null) {
      _order = widget.orderData!;
      // Set current step based on status
      _setCurrentStepFromStatus(_order.status);
    } else {
      // Create a dummy order for testing
      _order = OrderModel(
        id: widget.orderId,
        userId: 'unknown',
        items: [],
        subtotal: 0,
        tax: 0,
        shippingCost: 0,
        discountAmount: 0,
        total: 0,
        status: 'pending',
        deliveryAddress: '',
        orderedAt: DateTime.now(),
      );
      _setCurrentStepFromStatus(_order.status);
    }
  }

  void _setCurrentStepFromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        currentStep = 0;
        break;
      case 'in progress':
      case 'preparing':
        currentStep = 1;
        break;
      case 'on the way':
      case 'delivering':
        currentStep = 2;
        break;
      case 'delivered':
      case 'completed':
        currentStep = 3;
        break;
      default:
        currentStep = 1;
    }
  }

  StatusType _getStatusType(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return StatusType.success;
      case 'in progress':
      case 'preparing':
        return StatusType.warning;
      case 'on the way':
      case 'delivering':
        return StatusType.info;
      case 'cancelled':
        return StatusType.error;
      default:
        return StatusType.warning;
    }
  }

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://images.pexels.com/photos/1126359/pexels-photo-1126359.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: lightGrayColor,
                          child: const Icon(Icons.image_not_supported, size: 60),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
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
                          _order.id,
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
                            Expanded(
                              child: Text(
                                'Food App Restaurant',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(
                              label: _order.status,
                              type: _getStatusType(_order.status),
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
                                              color: primaryColor.withValues(alpha: 0.3),
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
                                        color: primaryColor.withValues(alpha: 0.7),
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
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: primaryColor.withValues(alpha: 0.3),
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
                      onPressed: () async {
                        // Get delivery address from order data
                        final address = _order.deliveryAddress;
                        final encodedAddress = Uri.encodeComponent(address);
                        final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
                        
                        try {
                          final uri = Uri.parse(googleMapsUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            // Fallback: open in browser
                            await launchUrl(uri, mode: LaunchMode.platformDefault);
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tidak dapat membuka peta: $e'),
                                backgroundColor: errorColor,
                              ),
                            );
                          }
                        }
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
                      onPressed: () async {
                        // Create share content
                        final orderId = _order.id;
                        final status = _order.status;
                        final itemsText = _order.itemsDisplay;
                        
                        final shareText = '''🍔 Pesanan dari Food App!

📋 Order ID: $orderId
🏪 Restaurant: Food App Restaurant
📦 Status: $status
🍽️ Items: $itemsText

Download Food App sekarang untuk pesan makanan favoritmu!''';
                        
                        // Copy to clipboard and show share dialog
                        await Clipboard.setData(ClipboardData(text: shareText));
                        
                        if (mounted) {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.7,
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: lightGrayColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: successColor.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_circle, color: successColor, size: 40),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Tersalin ke Clipboard!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Info pesanan telah disalin',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: darkGrayColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: lightGrayColor),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '🍔 Pesanan dari Food App!',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                                        ),
                                        const SizedBox(height: 8),
                                        _ShareInfoRow(icon: '📋', label: 'Order ID', value: orderId),
                                        _ShareInfoRow(icon: '🏪', label: 'Restaurant', value: 'Food App Restaurant'),
                                        _ShareInfoRow(icon: '📦', label: 'Status', value: status),
                                        _ShareInfoRow(icon: '🍽️', label: 'Items', value: itemsText),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Tutup',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
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

class _ShareInfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _ShareInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: darkGrayColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

