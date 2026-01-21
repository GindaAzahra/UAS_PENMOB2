import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF2D3436),
    this.elevation = 0,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: showBackButton
          ? GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: textColor),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class EmptyStateWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget? actionButton;

  const EmptyStateWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: darkGrayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (actionButton != null) ...[
            const SizedBox(height: 24),
            actionButton!,
          ],
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: darkGrayColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: darkGrayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String discount;
  final Color backgroundColor;
  final VoidCallback onTap;

  const PromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.discount,
    this.backgroundColor = primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withAlpha(51),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                discount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final TextStyle? style;

  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (originalPrice != null && originalPrice! > price)
          Text(
            'Rp ${originalPrice!.toStringAsFixed(0)}',
            style: (style ?? const TextStyle()).copyWith(
              fontSize: 11,
              color: darkGrayColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Text(
          'Rp ${price.toStringAsFixed(0)}',
          style: (style ?? const TextStyle()).copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            totalSteps,
            (index) => Expanded(
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: index < currentStep ? successColor : (index == currentStep - 1 ? primaryColor : lightGrayColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: index < currentStep
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: index == currentStep - 1 ? Colors.white : darkGrayColor,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index],
                    style: const TextStyle(fontSize: 11, color: darkGrayColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(
            totalSteps - 1,
            (index) => Expanded(
              child: Container(
                height: 2,
                color: index < currentStep - 1 ? successColor : lightGrayColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
