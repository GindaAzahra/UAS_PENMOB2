import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../services/cart_service.dart';
import 'advanced_checkout_screen.dart';

class EnhancedCartScreen extends StatefulWidget {
  const EnhancedCartScreen({super.key});

  @override
  State<EnhancedCartScreen> createState() => _EnhancedCartScreenState();
}

class _EnhancedCartScreenState extends State<EnhancedCartScreen> {
  final CartService _cartService = CartService();
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    _promoController.dispose();
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  void _updateQuantity(int foodId, int change) {
    HapticFeedback.lightImpact();
    final item = _cartService.items.firstWhere((item) => item.foodId == foodId);
    _cartService.updateQuantity(foodId, item.quantity + change);
  }

  void _removeItem(int foodId) {
    HapticFeedback.mediumImpact();
    final item = _cartService.items.firstWhere((item) => item.foodId == foodId);
    
    setState(() {
      _cartService.removeItem(foodId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('${item.foodName} dihapus dari keranjang')),
          ],
        ),
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _cartService.addItem(
                {
                  'id': item.foodId,
                  'name': item.foodName,
                  'price': item.price,
                  'image': item.image,
                },
                quantity: item.quantity,
                notes: item.notes,
              );
            });
          },
        ),
      ),
    );
  }

  void _applyPromo() {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;
    
    final success = _cartService.applyPromo(code);
    
    setState(() {
      if (success) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.celebration, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Promo $code diterapkan!', style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('Hemat Rp ${_cartService.discountAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: successColor,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(child: Text('Kode promo tidak valid atau sudah expired')),
              ],
            ),
            backgroundColor: errorColor,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
  }

  void _removePromo() {
    setState(() {
      _cartService.removePromo();
      _promoController.clear();
    });
  }

  void _showNotesDialog(CartItemModel item) {
    final notesController = TextEditingController(text: item.notes);
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_note, color: primaryColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan Pesanan',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Tambahkan instruksi khusus',
                          style: TextStyle(fontSize: 12, color: darkGrayColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: notesController,
                maxLines: 4,
                autofocus: true,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Contoh: Tidak pedas, extra saus, tanpa bawang',
                  hintStyle: TextStyle(color: darkGrayColor.withOpacity(0.5)),
                  filled: true,
                  fillColor: lightGrayColor.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: darkGrayColor.withOpacity(0.3)),
                      ),
                      child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _cartService.updateNotes(item.foodId, notesController.text);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text('Catatan berhasil disimpan'),
                              ],
                            ),
                            backgroundColor: successColor,
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_cartService.hasItems()) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Keranjang Belanja',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 70,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const Text(
                        'Keranjang Kosong',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada item di keranjang Anda.\nYuk, mulai berbelanja sekarang!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: darkGrayColor.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to home screen (shop menu)
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Mulai Belanja',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: Text(
          'Keranjang (${_cartService.itemCount})',
          style: const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (_cartService.hasItems())
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Kosongkan Keranjang?'),
                    content: const Text('Semua item akan dihapus dari keranjang Anda.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _cartService.clear();
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: errorColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Hapus Semua', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, color: errorColor),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Cart Items Container
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '📦 Item Pesanan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              '${_cartService.itemCount} item',
                              style: const TextStyle(
                                fontSize: 13,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._cartService.items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Column(
                            children: [
                              if (index > 0) const Divider(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: lightGrayColor,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.image_not_supported, size: 40);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.foodName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${item.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor,
                                          ),
                                        ),
                                        if (item.notes.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '📝 ${item.notes}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: darkGrayColor,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Quantity Controls
                                            Container(
                                              decoration: BoxDecoration(
                                                color: backgroundColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    onPressed: () => _updateQuantity(item.foodId, -1),
                                                    icon: const Icon(Icons.remove, size: 18),
                                                    color: primaryColor,
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    child: Text(
                                                      item.quantity.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () => _updateQuantity(item.foodId, 1),
                                                    icon: const Icon(Icons.add, size: 18),
                                                    color: Colors.white,
                                                    style: IconButton.styleFrom(
                                                      backgroundColor: primaryColor,
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Actions
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () => _showNotesDialog(item),
                                                  icon: const Icon(Icons.edit_note_outlined, size: 20),
                                                  color: primaryColor,
                                                  tooltip: 'Tambah catatan',
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                ),
                                                const SizedBox(width: 4),
                                                IconButton(
                                                  onPressed: () => _removeItem(item.foodId),
                                                  icon: const Icon(Icons.delete_outline, size: 20),
                                                  color: errorColor,
                                                  tooltip: 'Hapus',
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  // Promo Code Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎁 Kode Promo',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (!_cartService.isPromoApplied) ...[
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _promoController,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan kode promo',
                                    hintStyle: const TextStyle(color: darkGrayColor, fontSize: 13),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: lightGrayColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: lightGrayColor),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _applyPromo,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Pakai',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['WELCOME20', 'ALIYA15', 'FOOD10', 'FREESHIP']
                                .map((code) => GestureDetector(
                                      onTap: () {
                                        _promoController.text = code;
                                        _applyPromo();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: primaryColor.withOpacity(0.3)),
                                        ),
                                        child: Text(
                                          code,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: successColor.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: successColor, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Promo ${_cartService.promoCode} aktif',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: successColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Hemat Rp ${_cartService.discountAmount.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: successColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: _removePromo,
                                  icon: const Icon(Icons.close, size: 18),
                                  color: successColor,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price Summary
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💰 Ringkasan Pembayaran',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _PriceSummaryRow('Subtotal', 'Rp ${_cartService.subtotal.toStringAsFixed(0)}'),
                        const SizedBox(height: 10),
                        _PriceSummaryRow('Pajak (10%)', 'Rp ${_cartService.tax.toStringAsFixed(0)}'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ongkos Kirim',
                              style: TextStyle(fontSize: 13, color: darkGrayColor),
                            ),
                            Row(
                              children: [
                                if (_cartService.subtotal >= 50000)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: successColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'GRATIS',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: successColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  _cartService.deliveryFee == 0
                                      ? 'Rp 0'
                                      : 'Rp ${_cartService.deliveryFee.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _cartService.deliveryFee == 0 ? successColor : textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_cartService.isPromoApplied) ...[
                          const SizedBox(height: 10),
                          _PriceSummaryRow(
                            'Diskon Promo',
                            '-Rp ${_cartService.discountAmount.toStringAsFixed(0)}',
                            isDiscount: true,
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Divider(color: lightGrayColor, height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Bayar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Rp ${_cartService.total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Bottom Checkout Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdvancedCheckoutScreen(
                        totalPrice: _cartService.total,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${_cartService.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          'Lanjut Checkout',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;

  const _PriceSummaryRow(this.label, this.value, {this.isDiscount = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDiscount ? successColor : darkGrayColor,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: isDiscount ? successColor : textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
