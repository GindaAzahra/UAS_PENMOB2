import 'package:flutter/material.dart';
import '../utils/constants.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dompet & Pembayaran',
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
            // Balance Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Dompet',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rp 245,000',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _WalletAction(
                          icon: Icons.add_circle_outline,
                          label: 'Top Up',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Membuka halaman top up...'),
                                backgroundColor: primaryColor,
                              ),
                            );
                          },
                        ),
                        _WalletAction(
                          icon: Icons.send,
                          label: 'Transfer',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Membuka halaman transfer...'),
                                backgroundColor: primaryColor,
                              ),
                            );
                          },
                        ),
                        _WalletAction(
                          icon: Icons.history,
                          label: 'Riwayat',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Payment Methods
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PaymentMethodCard(
                    icon: '💳',
                    name: 'Kartu Kredit',
                    details: '•••• •••• •••• 4242',
                    isSelected: selectedPaymentMethod == 0,
                    onTap: () => setState(() => selectedPaymentMethod = 0),
                  ),
                  _PaymentMethodCard(
                    icon: '🏦',
                    name: 'Transfer Bank',
                    details: 'BRI - Rekening 123456789',
                    isSelected: selectedPaymentMethod == 1,
                    onTap: () => setState(() => selectedPaymentMethod = 1),
                  ),
                  _PaymentMethodCard(
                    icon: '📱',
                    name: 'E-Wallet',
                    details: 'GoPay (+62 812-3456-7890)',
                    isSelected: selectedPaymentMethod == 2,
                    onTap: () => setState(() => selectedPaymentMethod = 2),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tambah metode pembayaran baru...'),
                          backgroundColor: primaryColor,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Tambah Metode Pembayaran',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Transaction History
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TransactionItem(
                    icon: '🍱',
                    title: 'Pesanan - Nasi Goreng',
                    amount: '-Rp 25,000',
                    date: '15 Jan 2026, 14:30',
                    isDebit: true,
                  ),
                  _TransactionItem(
                    icon: '💰',
                    title: 'Top Up Saldo',
                    amount: '+Rp 100,000',
                    date: '14 Jan 2026, 10:15',
                    isDebit: false,
                  ),
                  _TransactionItem(
                    icon: '🎁',
                    title: 'Bonus Referral',
                    amount: '+Rp 50,000',
                    date: '13 Jan 2026, 09:00',
                    isDebit: false,
                  ),
                  _TransactionItem(
                    icon: '🍱',
                    title: 'Pesanan - Satay Chicken',
                    amount: '-Rp 28,000',
                    date: '12 Jan 2026, 19:45',
                    isDebit: true,
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

class _WalletAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _WalletAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String icon;
  final String name;
  final String details;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.name,
    required this.details,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : lightGrayColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 10,
                      color: darkGrayColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String icon;
  final String title;
  final String amount;
  final String date;
  final bool isDebit;

  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.amount,
    required this.date,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: lightGrayColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: lightGrayColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 10,
                    color: darkGrayColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDebit ? errorColor : successColor,
            ),
          ),
        ],
      ),
    );
  }
}

