import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/cart_service.dart';

class AdvancedCheckoutScreen extends StatefulWidget {
  final double totalPrice;
  
  const AdvancedCheckoutScreen({super.key, this.totalPrice = 0});

  @override
  State<AdvancedCheckoutScreen> createState() => _AdvancedCheckoutScreenState();
}

class _AdvancedCheckoutScreenState extends State<AdvancedCheckoutScreen> with TickerProviderStateMixin {
  final CartService _cartService = CartService();
  int currentStep = 0;
  String selectedAddress = '0';
  int selectedPaymentMethod = 0;
  bool isProcessing = false;
  late AnimationController _submitController;
  late AnimationController _successController;

  final List<Map<String, String>> addresses = [
    {
      'id': '0',
      'name': 'Rumah',
      'address': 'Jl. Merdeka No. 123, Jakarta Selatan 12234',
      'phone': '+62 812-3456-7890',
      'icon': 'home',
    },
    {
      'id': '1',
      'name': 'Kantor',
      'address': 'Jl. Sudirman No. 456, Jakarta Pusat 12210',
      'phone': '+62 812-3456-7890',
      'icon': 'business',
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 0,
      'name': 'E-Wallet (GoPay)',
      'icon': 'wallet',
      'details': '+62 812-3456-7890',
    },
    {
      'id': 1,
      'name': 'Kartu Kredit',
      'icon': 'card',
      'details': '•••• •••• •••• 4242',
    },
    {
      'id': 2,
      'name': 'Transfer Bank',
      'icon': 'bank',
      'details': 'BRI - Rekening 123456789',
    },
    {
      'id': 3,
      'name': 'Bayar di Tempat (COD)',
      'icon': 'cash',
      'details': 'Cash On Delivery',
    },
  ];

  @override
  void initState() {
    super.initState();
    _submitController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _submitController.dispose();
    _successController.dispose();
    super.dispose();
  }

  IconData _getAddressIcon(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'business':
        return Icons.business;
      default:
        return Icons.location_on;
    }
  }

  IconData _getPaymentIcon(String iconName) {
    switch (iconName) {
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'card':
        return Icons.credit_card;
      case 'bank':
        return Icons.account_balance;
      case 'cash':
        return Icons.local_atm;
      default:
        // Fallback untuk emoji atau string lain
        if (iconName.length < 5) {
          // Kemungkinan emoji
          return Icons.payment;
        }
        return Icons.payment;
    }
  }

  void _showOrderConfirmed() {
    _successController.forward();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: successColor, size: 50),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pesanan Berhasil!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pesanan Anda sedang diproses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: darkGrayColor,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontSize: 13)),
                        Text(
                          'Rp ${_cartService.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Metode Pembayaran', style: TextStyle(fontSize: 13)),
                        Text(
                          paymentMethods[selectedPaymentMethod]['name'],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _cartService.clear();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: primaryColor),
                      ),
                      child: const Text(
                        'Ke Beranda',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _cartService.clear();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Lacak Pesanan',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      _successController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Checkout',
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
            // Step Indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StepIndicator(
                    number: 1,
                    label: 'Alamat',
                    isActive: currentStep >= 0,
                    isCompleted: currentStep > 0,
                  ),
                  Container(
                    height: 2,
                    width: 40,
                    color: currentStep > 0 ? primaryColor : lightGrayColor,
                  ),
                  _StepIndicator(
                    number: 2,
                    label: 'Pembayaran',
                    isActive: currentStep >= 1,
                    isCompleted: currentStep > 1,
                  ),
                  Container(
                    height: 2,
                    width: 40,
                    color: currentStep > 1 ? primaryColor : lightGrayColor,
                  ),
                  _StepIndicator(
                    number: 3,
                    label: 'Konfirmasi',
                    isActive: currentStep >= 2,
                    isCompleted: false,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Step Content
            if (currentStep == 0) _buildAddressStep(),
            if (currentStep == 1) _buildPaymentStep(),
            if (currentStep == 2) _buildConfirmationStep(),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => currentStep--),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentStep < 2) {
                          setState(() => currentStep++);
                        } else {
                          _showOrderConfirmed();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        currentStep < 2 ? 'Lanjutkan' : 'Konfirmasi Pesanan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Alamat Pengiriman',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...addresses.map((address) {
            return GestureDetector(
              onTap: () => setState(() => selectedAddress = address['id']!),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selectedAddress == address['id'] ? primaryColor.withOpacity(0.05) : Colors.white,
                  border: Border.all(
                    color: selectedAddress == address['id']
                        ? primaryColor
                        : const Color(0xFFE8E8E8),
                    width: selectedAddress == address['id'] ? 2 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          address['icon'] == 'home' ? Icons.home_rounded : Icons.business_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address['name']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            address['address']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: darkGrayColor,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            address['phone']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedAddress == address['id'])
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tambah alamat baru...'),
                  backgroundColor: primaryColor,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
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
                    'Tambah Alamat Baru',
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
    );
  }

  Widget _buildPaymentStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...paymentMethods.map((method) {
            return GestureDetector(
              onTap: () => setState(() => selectedPaymentMethod = method['id']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selectedPaymentMethod == method['id'] ? primaryColor.withOpacity(0.05) : Colors.white,
                  border: Border.all(
                    color: selectedPaymentMethod == method['id']
                        ? primaryColor
                        : const Color(0xFFE8E8E8),
                    width: selectedPaymentMethod == method['id'] ? 2 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          method['icon'] == 'wallet' ? Icons.account_balance_wallet_rounded :
                          method['icon'] == 'card' ? Icons.credit_card_rounded :
                          method['icon'] == 'bank' ? Icons.account_balance_rounded :
                          Icons.payments_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            method['details'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedPaymentMethod == method['id'])
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    final checkoutData = _cartService.getCheckoutData();
    final subtotal = checkoutData['subtotal'] as double;
    final tax = checkoutData['tax'] as double;
    final deliveryFee = checkoutData['deliveryFee'] as double;
    final discount = checkoutData['discount'] as double;
    final total = checkoutData['total'] as double;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: lightGrayColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Items
                const Text(
                  'Item Pesanan:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cartService.items.length,
                  separatorBuilder: (context, index) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final item = _cartService.items[index];
                    return Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: lightGrayColor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported, size: 24);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.foodName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.quantity}x Rp ${item.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkGrayColor,
                                ),
                              ),
                              if (item.notes.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Note: ${item.notes}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: primaryColor.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          'Rp ${item.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Divider(height: 24),
                // Price breakdown
                _buildPriceRow('Subtotal', subtotal),
                const SizedBox(height: 8),
                _buildPriceRow('Pajak (10%)', tax),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ongkos Kirim',
                      style: TextStyle(fontSize: 12, color: darkGrayColor),
                    ),
                    Row(
                      children: [
                        if (deliveryFee == 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'GRATIS',
                              style: TextStyle(
                                fontSize: 9,
                                color: successColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Text(
                          'Rp ${deliveryFee.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: deliveryFee == 0 ? successColor : textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (discount > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Diskon (${_cartService.promoCode})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '-Rp ${discount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: successColor,
                        ),
                      ),
                    ],
                  ),
                ],
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Bayar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Rp ${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Address
          const Text(
            'Alamat Pengiriman',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: lightGrayColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          addresses.firstWhere((addr) => addr['id'] == selectedAddress)['icon'] == 'home' ? Icons.home_rounded : Icons.business_rounded,
                          color: primaryColor,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addresses.firstWhere((addr) => addr['id'] == selectedAddress)['name']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            addresses.firstWhere((addr) => addr['id'] == selectedAddress)['address']!,
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
          ),
          const SizedBox(height: 16),
          // Payment Method
          const Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: lightGrayColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      paymentMethods[selectedPaymentMethod]['icon'] == 'wallet' ? Icons.account_balance_wallet_rounded :
                      paymentMethods[selectedPaymentMethod]['icon'] == 'card' ? Icons.credit_card_rounded :
                      paymentMethods[selectedPaymentMethod]['icon'] == 'bank' ? Icons.account_balance_rounded :
                      Icons.payments_rounded,
                      color: primaryColor,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethods[selectedPaymentMethod]['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        paymentMethods[selectedPaymentMethod]['details'],
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
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: darkGrayColor,
          ),
        ),
        Text(
          'Rp ${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted || isActive ? primaryColor : lightGrayColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    number.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : darkGrayColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? primaryColor : darkGrayColor,
          ),
        ),
      ],
    );
  }
}

