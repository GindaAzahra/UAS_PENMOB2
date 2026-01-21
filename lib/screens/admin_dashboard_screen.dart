import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final authService = AuthService();
  String? userName;
  int _selectedMenuIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final name = await authService.getUserName();
    setState(() {
      userName = name;
    });
  }

  void _logout() async {
    await authService.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: isMobile
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 280,
          decoration: const BoxDecoration(
            color: Color(0xFF2E5090),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              // Logo Section
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Aliya Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Panel Administrator',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              
              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    _MenuItem(
                      icon: Icons.dashboard,
                      label: 'Dashboard',
                      isActive: _selectedMenuIndex == 0,
                      onTap: () {
                        setState(() => _selectedMenuIndex = 0);
                      },
                    ),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.food_bank,
                      label: 'Foods',
                      isActive: _selectedMenuIndex == 1,
                      onTap: () {
                        setState(() => _selectedMenuIndex = 1);
                      },
                    ),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.store,
                      label: 'Restaurants',
                      isActive: _selectedMenuIndex == 2,
                      onTap: () {
                        setState(() => _selectedMenuIndex = 2);
                      },
                    ),
                    const SizedBox(height: 8),
                    _MenuItem(
                      icon: Icons.receipt_long,
                      label: 'Orders',
                      isActive: _selectedMenuIndex == 3,
                      onTap: () {
                        setState(() => _selectedMenuIndex = 3);
                      },
                    ),
                  ],
                ),
              ),

              // User Info & Logout
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00A86B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName ?? 'Admin',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Administrator',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 16),
                            SizedBox(width: 8),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Main Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, $userName! 👋',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Here\'s what\'s happening with your business today.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB800).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFFB800).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFFFFB800),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Today, Jan 15',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Stats Grid
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.1,
                  children: [
                    _StatCard(
                      title: 'Total Orders',
                      value: '156',
                      change: '+12%',
                      icon: Icons.shopping_cart,
                      color: const Color(0xFF00A86B),
                      bgColor: const Color(0xFF00A86B).withOpacity(0.1),
                    ),
                    _StatCard(
                      title: 'Total Revenue',
                      value: 'Rp 2.4M',
                      change: '+8%',
                      icon: Icons.attach_money,
                      color: const Color(0xFFFFB800),
                      bgColor: const Color(0xFFFFB800).withOpacity(0.1),
                    ),
                    _StatCard(
                      title: 'Active Users',
                      value: '342',
                      change: '+15%',
                      icon: Icons.people,
                      color: const Color(0xFF2E5090),
                      bgColor: const Color(0xFF2E5090).withOpacity(0.1),
                    ),
                    _StatCard(
                      title: 'Restaurants',
                      value: '24',
                      change: '+3',
                      icon: Icons.restaurant,
                      color: const Color(0xFFFF6B6B),
                      bgColor: const Color(0xFFFF6B6B).withOpacity(0.1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Container(
          color: const Color(0xFF2E5090),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: _logout,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, $userName! 👋',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here\'s what\'s happening today.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    _StatCard(
                      title: 'Total Orders',
                      value: '156',
                      change: '+12%',
                      icon: Icons.shopping_cart,
                      color: const Color(0xFF00A86B),
                      bgColor: const Color(0xFF00A86B).withOpacity(0.1),
                    ),
                    _StatCard(
                      title: 'Total Revenue',
                      value: 'Rp 2.4M',
                      change: '+8%',
                      icon: Icons.attach_money,
                      color: const Color(0xFFFFB800),
                      bgColor: const Color(0xFFFFB800).withOpacity(0.1),
                    ),
                    _StatCard(
                      title: 'Active Users',
                      value: '342',
                      change: '+15%',
                      icon: Icons.people,
                      color: const Color(0xFF2E5090),
                      bgColor: const Color(0xFF2E5090).withOpacity(0.1),
                    ),
                    _StatCard(
                      title: 'Restaurants',
                      value: '24',
                      change: '+3',
                      icon: Icons.restaurant,
                      color: const Color(0xFFFF6B6B),
                      bgColor: const Color(0xFFFF6B6B).withOpacity(0.1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (isActive)
              const Spacer(),
            if (isActive)
              Container(
                width: 3,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
