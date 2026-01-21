import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'loyalty_program_screen.dart';
import 'special_deals_screen.dart';
import 'referral_program_screen.dart';
import 'customer_support_screen.dart';
import 'wallet_screen.dart';
import 'address_screen.dart';
import 'payment_method_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  String? userName;
  String? userEmail;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();
    _loadUserData();
  }

  void _loadUserData() async {
    final authService = AuthService();
    final name = await authService.getUserName();
    final email = await authService.getUserEmail();
    setState(() {
      userName = name ?? 'Pengguna';
      userEmail = email ?? 'user@email.com';
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final authService = AuthService();
              authService.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Keluar', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header (clean card layout)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, const Color(0xFF00A86B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Avatar + edit overlay
                      Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person, size: 40, color: primaryColor),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(Icons.edit, size: 18, color: primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? 'Pengguna',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail ?? 'user@email.com',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.16),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.star, size: 13, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('Member Silver', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoyaltyProgramScreen())),
                                  icon: const Icon(Icons.loyalty, size: 14),
                                  label: const Text('Lihat Program'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Account Section
              _buildSectionTitle('Akun'),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profil',
                      subtitle: 'Ubah informasi pribadi Anda',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat',
                      subtitle: 'Atur alamat pengiriman',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddressScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.payment_outlined,
                      title: 'Metode Pembayaran',
                      subtitle: 'Kelola kartu dan metode pembayaran',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentMethodScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Preferences Section
              _buildSectionTitle('Preferensi'),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.favorite_outline,
                      title: 'Favorit Saya',
                      subtitle: 'Makanan dan restoran pilihan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifikasi',
                      subtitle: 'Atur preferensi notifikasi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan',
                      subtitle: 'Ubah pengaturan aplikasi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Rewards & Programs Section
              _buildSectionTitle('Program & Hadiah'),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.loyalty_outlined,
                      title: 'Program Loyalitas',
                      subtitle: 'Dapatkan poin setiap pembelian',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoyaltyProgramScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.local_offer_outlined,
                      title: 'Penawaran Spesial',
                      subtitle: 'Diskon dan promosi eksklusif',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SpecialDealsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.card_giftcard_outlined,
                      title: 'Program Referral',
                      subtitle: 'Ajak teman dan dapatkan bonus',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReferralProgramScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Dompet Digital',
                      subtitle: 'Kelola saldo dan transaksi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WalletScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Support Section
              _buildSectionTitle('Bantuan & Dukungan'),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.chat_outlined,
                      title: 'Hubungi Kami',
                      subtitle: 'Dapatkan dukungan pelanggan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerSupportScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _MenuTile(
                      icon: Icons.help_outline,
                      title: 'Pusat Bantuan',
                      subtitle: 'FAQ dan panduan penggunaan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        errorColor.withOpacity(0.9),
                        Colors.red.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: errorColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleLogout,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Keluar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: darkGrayColor,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}

class _MenuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (isHovering) {
          setState(() {
            _isHovered = isHovering;
          });
        },
        child: Container(
          color: _isHovered ? Colors.grey.shade50 : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
