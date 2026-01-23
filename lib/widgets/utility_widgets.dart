import 'package:flutter/material.dart';
import '../utils/constants.dart';

// Animated Badge with Counter
class CounterBadge extends StatelessWidget {
  final int count;
  final Color backgroundColor;
  final TextStyle? textStyle;

  const CounterBadge({
    super.key,
    required this.count,
    this.backgroundColor = primaryColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: textStyle ?? const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Rating Display Component
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int reviews;
  final bool compact;

  const RatingDisplay({
    super.key,
    required this.rating,
    required this.reviews,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: accentColor, size: compact ? 14 : 16),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: compact ? 11 : 13,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 4),
          Text(
            '($reviews ulasan)',
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              color: darkGrayColor,
            ),
          ),
        ],
      ],
    );
  }
}

// Price Display with Original
class PriceDisplay extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final TextStyle? priceStyle;

  const PriceDisplay({
    super.key,
    required this.price,
    this.originalPrice,
    this.priceStyle,
  });

  @override
  Widget build(BuildContext context) {
    final discountPercent = originalPrice != null 
        ? ((originalPrice! - price) / originalPrice! * 100).toInt()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Rp ${price.toStringAsFixed(0)}',
              style: priceStyle ?? const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            if (originalPrice != null && originalPrice! > price) ...[
              const SizedBox(width: 8),
              Text(
                'Rp ${originalPrice!.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: darkGrayColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        if (discountPercent > 0) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '-$discountPercent%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: errorColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Status Badge/Chip
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    late Color backgroundColor;
    late Color textStyleColor;

    switch (type) {
      case StatusType.success:
        backgroundColor = successColor.withValues(alpha: 0.1);
        textStyleColor = successColor;
        break;
      case StatusType.warning:
        backgroundColor = warningColor.withValues(alpha: 0.1);
        textStyleColor = warningColor;
        break;
      case StatusType.error:
        backgroundColor = errorColor.withValues(alpha: 0.1);
        textStyleColor = errorColor;
        break;
      case StatusType.info:
        backgroundColor = infoColor.withValues(alpha: 0.1);
        textStyleColor = infoColor;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textStyleColor,
        ),
      ),
    );
  }
}

enum StatusType { success, warning, error, info }

// Expandable Feature List
class FeatureExpandable extends StatefulWidget {
  final String title;
  final List<String> features;
  final String icon;

  const FeatureExpandable({
    super.key,
    required this.title,
    required this.features,
    required this.icon,
  });

  @override
  State<FeatureExpandable> createState() => _FeatureExpandableState();
}

class _FeatureExpandableState extends State<FeatureExpandable> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: lightGrayColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(widget.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(color: lightGrayColor, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 11,
                              color: darkGrayColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Info Card with Icon
class InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor ?? primaryColor.withValues(alpha: 0.05),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: darkGrayColor,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

// Divider with Text
class DividerWithText extends StatelessWidget {
  final String text;
  final Color? dividerColor;
  final TextStyle? textStyle;

  const DividerWithText({
    super.key,
    required this.text,
    this.dividerColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor ?? lightGrayColor,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: textStyle ?? const TextStyle(
              fontSize: 11,
              color: darkGrayColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor ?? lightGrayColor,
            height: 1,
          ),
        ),
      ],
    );
  }
}

