import 'package:flutter/material.dart';

// Professional Color Scheme v2.0
const Color primaryColor = Color(0xFF00A86B);      // Jade Green
const Color secondaryColor = Color(0xFF2E5090);    // Deep Blue
const Color accentColor = Color(0xFFFFB800);       // Amber Gold
const Color backgroundColor = Color(0xFFF8F9FA);   // Light Gray
const Color textColor = Color(0xFF1A202C);         // Dark Charcoal
const Color lightGrayColor = Color(0xFFE8ECEF);    // Neutral Gray
const Color darkGrayColor = Color(0xFF718096);     // Medium Gray
const Color errorColor = Color(0xFFDC2626);        // Vibrant Red
const Color successColor = Color(0xFF059669);      // Success Green
const Color warningColor = Color(0xFFEA580C);      // Warning Orange
const Color infoColor = Color(0xFF0284C7);         // Info Blue

// Gradients
const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryColor, Color(0xFF00855E)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient accentGradient = LinearGradient(
  colors: [accentColor, Color(0xFFFFA500)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Dummy Data - Updated with Reliable Food Images for Web
final List<Map<String, dynamic>> dummyFoods = [
  {
    'id': 101,
    'name': 'Pasta',
    'category': 'Meat',
    'price': 32000.0,
    'rating': 4.9,
    'reviews': 342,
    'image': 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=1400',
    'description': 'Ayam panggang bumbu tradisional dengan nasi uduk dan sambal hijau',
    'ingredients': ['Ayam', 'Nasi Uduk', 'Sambal', 'Daun Jeruk'],
  },
  {
    'id': 102,
    'name': 'Cemilan manis',
    'category': 'Meat',
    'price': 36000.0,
    'rating': 4.8,
    'reviews': 278,
    'image': 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg?auto=compress&cs=tinysrgb&w=1400',
    'description': 'Bebek kecap manis dengan lalapan segar dan sambal cabai rawit',
    'ingredients': ['Bebek', 'Kecap Manis', 'Cabe Rawit', 'Lalapan'],
  },
  {
    'id': 103,
    'name': 'Kebab',
    'category': 'Seafood',
    'price': 29000.0,
    'rating': 4.7,
    'reviews': 214,
    'image': 'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&w=1400',
    'description': 'Cumi saus padang pedas dengan kentang goreng renyah',
    'ingredients': ['Cumi', 'Saus Padang', 'Kentang', 'Cabe'],
  },
  
  
  {
    'id': 106,
    'name': 'Daging Salat',
    'category': 'Meat',
    'price': 42000.0,
    'rating': 4.8,
    'reviews': 233,
    'image': 'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg?auto=compress&cs=tinysrgb&w=1400',
    'description': 'Kambing guling dengan rempah Madura dan sambal matah khas Bali',
    'ingredients': ['Kambing', 'Rempah', 'Sambal Matah', 'Bawang'],
  },
  {
    'id': 107,
    'name': 'Resep Sayur Warna',
    'category': 'Vegetable',
    'price': 22000.0,
    'rating': 4.5,
    'reviews': 156,
    'image': 'https://images.pexels.com/photos/257816/pexels-photo-257816.jpeg?auto=compress&cs=tinysrgb&w=1400',
    'description': 'Sayur campur hijau dengan saus kacang dan kerupuk emping',
    'ingredients': ['Sayuran', 'Kacang', 'Kerupuk', 'Lada'],
  },
];

final List<Map<String, dynamic>> dummyRestaurants = [
  {
    'id': 1,
    'name': 'Rumah Makan Padang',
    'rating': 4.6,
    'reviews': 458,
    'image': 'https://images.unsplash.com/photo-1545665225-f42615cb6739?w=500&h=500&fit=crop',
    'description': 'Masakan Padang autentik dengan cita rasa tradisional',
    'address': 'Jl. Merdeka No. 123',
  },
  {
    'id': 2,
    'name': 'Warung Nasi Kucing',
    'rating': 4.3,
    'reviews': 234,
    'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&h=500&fit=crop',
    'description': 'Nasi kucing dengan lauk pauk pilihan',
    'address': 'Jl. Sudirman No. 45',
  },
  {
    'id': 3,
    'name': 'Kedai Soto Betawi',
    'rating': 4.7,
    'reviews': 567,
    'image': 'https://images.unsplash.com/photo-1626082927389-6cd097cfd330?w=500&h=500&fit=crop',
    'description': 'Soto Betawi dan gorengan khas Jakarta',
    'address': 'Jl. Gatot Subroto No. 78',
  },
];

// Special Deals & Promos
final List<Map<String, dynamic>> specialDeals = [
  {
    'id': 1,
    'title': 'Lunch Combo',
    'description': 'Hemat 25% untuk paket nasi + lauk + minum',
    'discount': 25,
    'icon': '🍱',
    'validUntil': '2025-01-30',
  },
  {
    'id': 2,
    'title': 'Free Delivery',
    'description': 'Gratis ongkir untuk order minimal Rp 75,000',
    'discount': 0,
    'icon': '🚚',
    'validUntil': '2025-01-31',
  },
  {
    'id': 3,
    'title': 'Bundle Deal',
    'description': 'Beli 2 gratis 1 untuk menu pilihan',
    'discount': 33,
    'icon': '🎁',
    'validUntil': '2025-01-28',
  },
  {
    'id': 4,
    'title': 'Weekend Special',
    'description': 'Hemat 30% untuk semua menu di weekend',
    'discount': 30,
    'icon': '⭐',
    'validUntil': '2025-01-26',
  },
];

// Testimonials/Reviews
final List<Map<String, dynamic>> testimonials = [
  {
    'name': 'Siti Nurhaliza',
    'rating': 5.0,
    'image': '👩‍🦰',
    'comment': 'Makanannya sangat lezat dan delivery cepat! Saya sangat puas.',
    'date': '2025-01-14',
  },
  {
    'name': 'Budi Santoso',
    'rating': 4.8,
    'image': '👨‍💼',
    'comment': 'Kualitas terbaik, harga terjangkau. Recommended!',
    'date': '2025-01-13',
  },
  {
    'name': 'Eka Putri',
    'rating': 5.0,
    'image': '👩‍🎓',
    'comment': 'Pelayanan ramah dan makanan selalu fresh. Keep it up!',
    'date': '2025-01-12',
  },
  {
    'name': 'Hendra Wijaya',
    'rating': 4.7,
    'image': '👨‍🍳',
    'comment': 'Aplikasinya user-friendly, proses order jadi lebih mudah.',
    'date': '2025-01-11',
  },
];

// Loyalty Program Data
final Map<String, dynamic> loyaltyProgram = {
  'currentPoints': 2450,
  'nextTier': 'Gold',
  'pointsToNextTier': 5000,
  'memberLevel': 'Silver',
  'benefits': [
    {
      'title': 'Reward Points',
      'description': 'Dapatkan poin setiap transaksi',
    },
    {
      'title': 'Diskon Eksklusif',
      'description': 'Member mendapat diskon hingga 20%',
    },
    {
      'title': 'Akses Early Promo',
      'description': 'Akses promo sebelum publik',
    },
    {
      'title': 'Free Delivery',
      'description': 'Gratis ongkir setiap minggu',
    },
  ],
  'pointsHistory': [
    {
      'date': '14 Januari 2025',
      'points': 250,
      'description': 'Pembelian Satay Chicken',
    },
    {
      'date': '12 Januari 2025',
      'points': 325,
      'description': 'Pembelian Bundle Nasi + Sup',
    },
    {
      'date': '10 Januari 2025',
      'points': 180,
      'description': 'Bonus referral teman',
    },
  ],
};

// Top Rated Foods
final List<Map<String, dynamic>> topRatedFoods = [
  {
    'id': 5,
    'name': '',
    'rating': 4.9,
    'badge': '⭐ Top Rated',
    'image': 'https://images.pexels.com/photos/262959/pexels-photo-262959.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
  {
    'id': 1,
    'name': 'Bief',
    'rating': 4.8,
    'badge': '🔥 Trending',
    'image': 'https://images.pexels.com/photos/1639563/pexels-photo-1639563.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
 
];

// Orders Data with Images
final List<Map<String, dynamic>> dummyOrders = [
  {
    'id': 'ORD001',
    'items': ['Nasi Goreng', 'Soto Ayam'],
    'total': 65000.0,
    'status': 'Delivered',
    'date': '12 January 2025',
    'image': 'https://images.pexels.com/photos/1126359/pexels-photo-1126359.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'deliveryTime': '30 mins',
    'restaurant': 'Rumah Makan Padang',
  },
  {
    'id': 'ORD002',
    'items': ['Satay Chicken', 'Lumpia'],
    'total': 40000.0,
    'status': 'In Progress',
    'date': '14 January 2025',
    'image': 'https://images.pexels.com/photos/4827720/pexels-photo-4827720.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'deliveryTime': '10 mins',
    'restaurant': 'Kedai Soto Betawi',
  },
  {
    'id': 'ORD003',
    'items': ['Gado-Gado', 'Lumpia'],
    'total': 32000.0,
    'status': 'Completed',
    'date': '10 January 2025',
    'image': 'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'deliveryTime': '25 mins',
    'restaurant': 'Warung Nasi Kucing',
  },
];

// Notifications Data with Images
final List<Map<String, dynamic>> dummyNotifications = [
  {
    'id': 1,
    'title': 'Pesanan Telah Tiba! 🎉',
    'description': 'Pesanan ORD002 telah diterima oleh driver',
    'icon': '📦',
    'image': 'https://images.pexels.com/photos/4827720/pexels-photo-4827720.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'time': '5 mins ago',
    'type': 'Pesanan',
    'isRead': false,
  },
  {
    'id': 2,
    'title': 'Promo Eksklusif! 🎁',
    'description': 'Dapatkan diskon 30% untuk pesanan berikutnya',
    'icon': '🎊',
    'image': 'https://images.pexels.com/photos/1126359/pexels-photo-1126359.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'time': '1 hour ago',
    'type': 'Promo',
    'isRead': false,
  },
  {
    'id': 3,
    'title': 'Rating Pesanan Anda ⭐',
    'description': 'Bagaimana pengalaman Anda dengan pesanan kemarin?',
    'icon': '⭐',
    'image': 'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'time': '2 hours ago',
    'type': 'Ulasan',
    'isRead': true,
  },
  {
    'id': 4,
    'title': 'Program Referral 💰',
    'description': 'Teman Anda telah mendaftar! Bonus Rp 50,000 menanti',
    'icon': '👥',
    'image': 'https://images.pexels.com/photos/5728295/pexels-photo-5728295.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'time': '3 hours ago',
    'type': 'Reward',
    'isRead': true,
  },
  {
    'id': 5,
    'title': 'Restoran Favorit Buka! 🍽️',
    'description': 'Rumah Makan Padang telah buka dan siap menerima pesanan',
    'icon': '🍽️',
    'image': 'https://images.pexels.com/photos/5848606/pexels-photo-5848606.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
    'time': 'Yesterday',
    'type': 'Restoran',
    'isRead': true,
  },
];

// Payment Methods Data
final List<Map<String, dynamic>> paymentMethods = [
  {
    'id': 'cc',
    'name': 'Credit Card Visa',
    'type': 'card',
    'icon': '💳',
    'description': '**** **** **** 4242',
    'isDefault': true,
    'image': 'https://images.pexels.com/photos/3962286/pexels-photo-3962286.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
  {
    'id': 'ew',
    'name': 'GCash Mobile',
    'type': 'ewallet',
    'icon': '📱',
    'description': '09*****1234',
    'isDefault': false,
    'image': 'https://images.pexels.com/photos/4386320/pexels-photo-4386320.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
  {
    'id': 'bank',
    'name': 'Bank Transfer',
    'type': 'bank',
    'icon': '🏦',
    'description': 'BCA - 1234567890',
    'isDefault': false,
    'image': 'https://images.pexels.com/photos/3585325/pexels-photo-3585325.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
];

// Wallet Transactions
final List<Map<String, dynamic>> walletTransactions = [
  {
    'id': 1,
    'type': 'debit',
    'description': 'Pesanan #ORD002',
    'amount': '40.000',
    'date': '14 Jan 2025',
    'time': '02:30 PM',
    'status': 'Success',
    'image': 'https://images.pexels.com/photos/4827720/pexels-photo-4827720.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
  {
    'id': 2,
    'type': 'credit',
    'description': 'Bonus Referral',
    'amount': '50.000',
    'date': '13 Jan 2025',
    'time': '10:15 AM',
    'status': 'Success',
    'image': 'https://images.pexels.com/photos/1126359/pexels-photo-1126359.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
  {
    'id': 3,
    'type': 'debit',
    'description': 'Pesanan #ORD001',
    'amount': '65.000',
    'date': '12 Jan 2025',
    'time': '06:45 PM',
    'status': 'Success',
    'image': 'https://images.pexels.com/photos/5848606/pexels-photo-5848606.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
  {
    'id': 4,
    'type': 'credit',
    'description': 'Top Up Saldo',
    'amount': '100.000',
    'date': '10 Jan 2025',
    'time': '03:20 PM',
    'status': 'Success',
    'image': 'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?auto=compress&cs=tinysrgb&w=500&h=500&fit=crop',
  },
];


