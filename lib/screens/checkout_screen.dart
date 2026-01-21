import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin {
  String selectedPayment = 'credit_card';
  bool agreeTerms = false;
  bool isProcessing = false;
  late AnimationController _paymentController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _paymentController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Syarat & Ketentuan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.close, size: 20, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    _TermsSection(
                      title: '1. Kebijakan Pembayaran',
                      content:
                          'Semua pembayaran harus dilakukan melalui metode yang tersedia di aplikasi. Pembayaran diterima dalam mata uang Rupiah (IDR).',
                    ),
                    _TermsSection(
                      title: '2. Kebijakan Pengiriman',
                      content:
                          'Pesanan akan dikirimkan sesuai dengan alamat yang telah Anda konfirmasi. Kami menjamin pengiriman tepat waktu atau uang kembali 50%.',
                    ),
                    _TermsSection(
                      title: '3. Kebijakan Pengembalian',
                      content:
                          'Produk yang dikirimkan harus dalam kondisi baik. Klaim pengembalian harus dilakukan dalam 24 jam setelah penerimaan.',
                    ),
                    _TermsSection(
                      title: '4. Privasi Data',
                      content:
                          'Data pribadi Anda akan dijaga dengan keamanan tingkat tinggi dan tidak akan dibagikan kepada pihak ketiga tanpa izin.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => agreeTerms = true);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Saya Setuju',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    if (!agreeTerms) {
      _showErrorDialog('Mohon setujui syarat dan ketentuan terlebih dahulu');
      return;
    }

    setState(() => isProcessing = true);
    _paymentController.forward();

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      _paymentController.reset();
      _showPaymentSuccessDialog();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.error_outline, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Perhatian', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    _successController.forward();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon with animation
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 24),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: primaryColor,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ),
                // Title
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Pesanan Anda telah dikonfirmasi.\nNomor pesanan: #ORD-2024-001',
                    style: TextStyle(
                      fontSize: 14,
                      color: darkGrayColor,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                // Order Details Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: lightGrayColor, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.payment,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Rp 79,800',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kartu Kredit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: darkGrayColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: lightGrayColor, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.schedule,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '30-45 Min',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Estimasi Tiba',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: darkGrayColor,
                                  fontWeight: FontWeight.w500,
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
                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: primaryColor, width: 1.5),
                          ),
                          child: const Text(
                            'Kembali',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Tracking',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
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
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: const Text(
          'Checkout',
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
            // Delivery Address
            const Text(
              'Alamat Pengiriman',
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
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jl. Merdeka No. 123',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kelurahan Sentosa, Kecamatan Maju, Jakarta Selatan',
                    style: TextStyle(
                      fontSize: 13,
                      color: darkGrayColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ubah Alamat',
                        style: TextStyle(
                          fontSize: 13,
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Order Summary
            const Text(
              'Ringkasan Pesanan',
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
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPricingRow('Subtotal', 'Rp 68,000'),
                  const SizedBox(height: 12),
                  _buildPricingRow('Pajak (10%)', 'Rp 6,800', isDark: true),
                  const SizedBox(height: 12),
                  _buildPricingRow('Ongkir', 'Rp 5,000', isDark: true),
                  const SizedBox(height: 14),
                  Divider(color: darkGrayColor.withAlpha(50), height: 1),
                  const SizedBox(height: 14),
                  _buildPricingRow(
                    'Total Pembayaran',
                    'Rp 79,800',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Payment Method
            const Text(
              'Metode Pembayaran',
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
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _PaymentOption(
                    title: 'Kartu Kredit',
                    icon: Icons.credit_card,
                    value: 'credit_card',
                    selectedValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                  ),
                  Divider(color: lightGrayColor, height: 0),
                  _PaymentOption(
                    title: 'Transfer Bank',
                    icon: Icons.account_balance,
                    value: 'bank_transfer',
                    selectedValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                  ),
                  Divider(color: lightGrayColor, height: 0),
                  _PaymentOption(
                    title: 'E-Wallet',
                    icon: Icons.wallet_giftcard,
                    value: 'ewallet',
                    selectedValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                  ),
                  Divider(color: lightGrayColor, height: 0),
                  _PaymentOption(
                    title: 'Tunai',
                    icon: Icons.money,
                    value: 'cash',
                    selectedValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Terms & Conditions
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
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Checkbox(
                    value: agreeTerms,
                    onChanged: (value) {
                      setState(() {
                        agreeTerms = value!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showTermsModal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saya setuju dengan syarat dan ketentuan layanan',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap untuk membaca lengkap →',
                            style: TextStyle(
                              fontSize: 11,
                              color: primaryColor,
                              fontStyle: FontStyle.italic,
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
            // Processing indicator
            if (isProcessing)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue.withOpacity(0.7)),
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Memproses pembayaran...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Harap tunggu beberapa saat',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (isProcessing) const SizedBox(height: 16),
            PrimaryButton(
              label: isProcessing ? 'Memproses...' : 'Konfirmasi Pembayaran',
              onPressed: isProcessing ? () {} : _processPayment,
            ),
          ],
        ),
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

class _PaymentOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.title,
    required this.icon,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: value,
      groupValue: selectedValue,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
      activeColor: primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;

  const _TermsSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
