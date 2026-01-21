import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = dummyFoods.take(3).toList();
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item['price'];
    }
    double tax = subtotal * 0.1;
    double discount = 0;
    double total = subtotal + tax + 5000 - discount;

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
          'Keranjang Belanja',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        '🛒',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Keranjang Kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Mulai belanja dan tambahkan makanan favorit ke keranjang Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: darkGrayColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    item['image'],
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Rp ${(item['price'] as num).toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: lightGrayColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Center(
                                                child: Text('−', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 32,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Center(
                                              child: Text('1', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Center(
                                                child: Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: errorColor.withAlpha(25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: errorColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: lightGrayColor, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            _buildPricingRow('Subtotal', 'Rp ${subtotal.toStringAsFixed(0)}'),
                            const SizedBox(height: 12),
                            _buildPricingRow('Pajak (10%)', 'Rp ${tax.toStringAsFixed(0)}', isDark: true),
                            const SizedBox(height: 12),
                            _buildPricingRow('Ongkir', 'Rp 5,000', isDark: true),
                            const SizedBox(height: 14),
                            Divider(color: darkGrayColor.withAlpha(50), height: 1),
                            const SizedBox(height: 14),
                            _buildPricingRow(
                              'Total Pembayaran',
                              'Rp ${total.toStringAsFixed(0)}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Lanjut ke Checkout',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPricingRow(String label, String value, {bool isDark = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isDark ? darkGrayColor : darkGrayColor.withAlpha(180),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.w700,
            color: isTotal ? primaryColor : textColor,
          ),
        ),
      ],
    );
  }
}

