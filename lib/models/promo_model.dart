class PromoCode {
  final String code;
  final double discountPercentage;
  final double minOrderAmount;
  final String description;
  final bool isActive;

  PromoCode({
    required this.code,
    required this.discountPercentage,
    required this.minOrderAmount,
    required this.description,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discountPercentage': discountPercentage,
      'minOrderAmount': minOrderAmount,
      'description': description,
      'isActive': isActive,
    };
  }

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      code: json['code'] ?? '',
      discountPercentage: json['discountPercentage'] ?? 0.0,
      minOrderAmount: json['minOrderAmount'] ?? 0.0,
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
}

class CartSummary {
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discountAmount;
  final double total;
  final PromoCode? appliedPromo;

  CartSummary({
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.discountAmount,
    required this.total,
    this.appliedPromo,
  });
}
