import 'package:flutter/material.dart';
import '../utils/constants.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyOrders.length,
        itemBuilder: (context, index) {
          final order = dummyOrders[index];
          return _OrderCard(
            order: order,
            onDetailTap: () {
              _showOrderDetail(context, order);
            },
          );
        },
      ),
    );
  }

  void _showOrderDetail(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order['id'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          _StatusBadge(status: order['status']),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tanggal Pesanan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['date'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Items yang Dipesan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        order['items'].length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Text(
                              '${i + 1}. ${order['items'][i]}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: darkGrayColor,
                                  ),
                                ),
                                Text(
                                  'Rp ${(order['total'] * 0.9).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Ongkir',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: darkGrayColor,
                                  ),
                                ),
                                Text(
                                  'Rp ${(order['total'] * 0.1).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  'Rp ${order['total'].toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onDetailTap;

  const _OrderCard({
    required this.order,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Column(
        children: [
          // Status Badge Area
          Container(
            width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: _getStatusColor(order['status']).withOpacity(0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusBadge(status: order['status']),
                  Text(
                    order['date'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Order Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['id'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order['status']).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(order['status']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Items Preview
                  ...List.generate(
                    order['items'].length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• ${order['items'][i]}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Total and Detail Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total: Rp ${order['total'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onDetailTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF10B981); // Green
      case 'in progress':
        return const Color(0xFFF59E0B); // Yellow/Amber
      case 'completed':
        return const Color(0xFFF59E0B); // Yellow/Amber
      case 'pending':
        return const Color(0xFF6B7280); // Gray
      default:
        return Colors.grey;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'delivered':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle;
        break;
      case 'in progress':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.hourglass_bottom;
        break;
      case 'completed':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.check;
        break;
      case 'pending':
        statusColor = const Color(0xFF6B7280);
        statusIcon = Icons.timer;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
