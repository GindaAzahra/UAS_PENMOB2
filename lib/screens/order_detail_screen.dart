import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

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
          'Detail Pesanan',
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
            // Order Status
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ID Pesanan',
                        style: TextStyle(
                          fontSize: 12,
                          color: darkGrayColor,
                        ),
                      ),
                      Text(
                        order['id'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: darkGrayColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: order['status'] == 'Delivered'
                              ? successColor.withAlpha(26)
                              : accentColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: order['status'] == 'Delivered' ? successColor : accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Items
            const Text(
              'Barang Pesanan',
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  order['items'].length,
                  (index) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order['items'][index],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          Text(
                            'x1',
                            style: const TextStyle(
                              fontSize: 14,
                              color: darkGrayColor,
                            ),
                          ),
                        ],
                      ),
                      if (index < order['items'].length - 1)
                        const Divider(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Delivery Info
            const Text(
              'Informasi Pengiriman',
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat Pengiriman',
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkGrayColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['deliveryAddress'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tanggal Pesanan',
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkGrayColor,
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Price Summary
            const Text(
              'Ringkasan Pembayaran',
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(fontSize: 14, color: darkGrayColor),
                      ),
                      Text(
                        'Rp ${(order['total'] * 0.8).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pajak (10%)',
                        style: TextStyle(fontSize: 14, color: darkGrayColor),
                      ),
                      Text(
                        'Rp ${(order['total'] * 0.08).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ongkir',
                        style: TextStyle(fontSize: 14, color: darkGrayColor),
                      ),
                      Text(
                        'Rp ${(order['total'] * 0.12).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: lightGrayColor),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Rp ${order['total'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Kembali ke Beranda',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
