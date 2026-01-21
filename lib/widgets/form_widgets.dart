import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final String hintText;

  const SearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Cari makanan atau restoran',
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {});
        },
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: darkGrayColor.withOpacity(0.6),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: _controller.text.isNotEmpty ? primaryColor : darkGrayColor,
              size: 24,
            ),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _controller.clear();
                      widget.onChanged('');
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.close_rounded,
                        color: darkGrayColor.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? primaryColor : lightGrayColor.withOpacity(0.5),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : textColor,
              letterSpacing: isSelected ? 0.3 : 0,
            ),
          ),
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final int reviews;
  final double size;

  const RatingBar({
    super.key,
    required this.rating,
    required this.reviews,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          size: size,
          color: accentColor,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: size - 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($reviews)',
          style: TextStyle(
            fontSize: size - 4,
            color: darkGrayColor,
          ),
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: lightGrayColor),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            minLines: maxLines > 1 ? maxLines : 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: darkGrayColor),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: primaryColor) : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(suffixIcon, color: darkGrayColor),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
