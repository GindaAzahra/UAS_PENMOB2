$file = "lib\screens\advanced_checkout_screen.dart"
$content = Get-Content -Path $file -Raw -Encoding UTF8

# Ganti payment methods
$content = $content -replace "final List<Map<String, dynamic>> paymentMethods = \[[^\]]*\];", @"
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
"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "File updated successfully!"
