#!/usr/bin/env python3
import re

file_path = 'lib/screens/advanced_checkout_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix Ringkasan header
old_ringkasan = """          const Text(
            'ðŸ"¦ Ringkasan Pesanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),"""

new_ringkasan = """          Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),"""

# Fix Alamat header
old_alamat = """          // Address
          const Text(
            'ðŸ" Alamat Pengiriman',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),"""

new_alamat = """          // Address
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Alamat Pengiriman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),"""

# Fix Metode Pembayaran header
old_metode = """          // Payment Method
          const Text(
            'ðŸ'³ Metode Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),"""

new_metode = """          // Payment Method
          Row(
            children: [
              Icon(Icons.payment_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),"""

# Replace all
content = content.replace(old_ringkasan, new_ringkasan)
content = content.replace(old_alamat, new_alamat)
content = content.replace(old_metode, new_metode)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Fixed all emoji headers!')
