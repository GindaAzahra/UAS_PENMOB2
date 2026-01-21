import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double padding;
  final bool fullWidth;
  final IconData? icon;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 14,
    this.padding = 16,
    this.fullWidth = true,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          width: fullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 1.2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLoading 
                ? [Colors.grey[400]!, Colors.grey[500]!]
                : [
                    backgroundColor ?? primaryColor,
                    (backgroundColor ?? primaryColor).withOpacity(0.85),
                  ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: isLoading ? [] : [
              BoxShadow(
                color: (backgroundColor ?? primaryColor).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor ?? Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 20,
                          color: textColor ?? Colors.white,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: textColor ?? Colors.white,
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
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double borderRadius;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.borderRadius = 14,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: (borderColor ?? primaryColor).withOpacity(0.08),
            border: Border.all(
              color: borderColor ?? primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: textColor ?? primaryColor,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor ?? primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
