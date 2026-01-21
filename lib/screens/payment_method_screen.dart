import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  List<Map<String, dynamic>> paymentMethods = [
    {
      'type': 'credit_card',
      'name': 'Visa',
      'last4': '4242',
      'expiryDate': '12/25',
      'isDefault': true,
    },
    {
      'type': 'debit_card',
      'name': 'Debit Mandiri',
      'last4': '8901',
      'expiryDate': '08/26',
      'isDefault': false,
    },
  ];

  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'credit_card':
        return Icons.credit_card;
      case 'debit_card':
        return Icons.payment;
      case 'ewallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  void _addPaymentMethod() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tambah Metode Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PaymentTypeButton(
                icon: Icons.credit_card,
                label: 'Kartu Kredit',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              _PaymentTypeButton(
                icon: Icons.payment,
                label: 'Kartu Debit',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              _PaymentTypeButton(
                icon: Icons.account_balance_wallet,
                label: 'E-Wallet',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: paymentMethods.length,
        itemBuilder: (context, index) {
          final method = paymentMethods[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: method['isDefault'] ? primaryColor : Colors.grey[300]!,
                width: method['isDefault'] ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getPaymentIcon(method['type']),
                            color: primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '**** ${method['last4']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkGrayColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (method['isDefault'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Berlaku hingga ${method['expiryDate']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: darkGrayColor,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                for (var m in paymentMethods) {
                                  m['isDefault'] = false;
                                }
                                method['isDefault'] = true;
                              });
                            },
                            child: const Text('Jadikan Default'),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text('Hapus'),
                                onTap: () {
                                  setState(() =>
                                      paymentMethods.removeAt(index));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _addPaymentMethod,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PaymentTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PaymentTypeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: primaryColor, size: 28),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward, color: darkGrayColor),
            ],
          ),
        ),
      ),
    );
  }
}
