import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/premium_widgets.dart';

class LoyaltyProgramScreen extends StatefulWidget {
  const LoyaltyProgramScreen({super.key});

  @override
  State<LoyaltyProgramScreen> createState() => _LoyaltyProgramScreenState();
}

class _LoyaltyProgramScreenState extends State<LoyaltyProgramScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Program Loyalitas',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Loyalty Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: LoyaltyCard(
                currentPoints: loyaltyProgram['currentPoints'],
                pointsNeeded: loyaltyProgram['pointsToNextTier'],
                memberLevel: loyaltyProgram['memberLevel'],
                nextTier: loyaltyProgram['nextTier'],
              ),
            ),

            // TabBar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: darkGrayColor,
                indicatorColor: primaryColor,
                tabs: const [
                  Tab(text: 'Manfaat'),
                  Tab(text: 'Riwayat'),
                  Tab(text: 'Tier'),
                ],
              ),
            ),

            // TabBarView
            SizedBox(
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Benefits Tab
                  _buildBenefitsTab(),
                  // History Tab
                  _buildHistoryTab(),
                  // Tiers Tab
                  _buildTiersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsTab() {
    final benefits = loyaltyProgram['benefits'] as List<dynamic>;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: benefits.length,
        itemBuilder: (context, index) {
          final benefit = benefits[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: lightGrayColor),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      _getBenefitIcon(benefit['title']),
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        benefit['title'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        benefit['description'],
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryTab() {
    final history = loyaltyProgram['pointsHistory'] as List<dynamic>;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final transaction = history[index];
          final isPositive = transaction['points'] > 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: lightGrayColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (isPositive ? primaryColor : errorColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      isPositive ? Icons.add : Icons.remove,
                      color: isPositive ? primaryColor : errorColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['description'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        transaction['date'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: darkGrayColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${transaction['points']} poin',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? primaryColor : errorColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTiersTab() {
    final tiers = [
      {
        'name': 'Bronze',
        'minPoints': 0,
        'maxPoints': 1000,
        'benefits': '5 benefits',
        'isActive': false,
      },
      {
        'name': 'Silver',
        'minPoints': 1000,
        'maxPoints': 5000,
        'benefits': '10 benefits',
        'isActive': true,
      },
      {
        'name': 'Gold',
        'minPoints': 5000,
        'maxPoints': 10000,
        'benefits': '15 benefits',
        'isActive': false,
      },
      {
        'name': 'Platinum',
        'minPoints': 10000,
        'maxPoints': 50000,
        'benefits': '20 benefits',
        'isActive': false,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: tiers.length,
        itemBuilder: (context, index) {
          final tier = tiers[index];
          final isActive = tier['isActive'] as bool;
          final tierName = tier['name'] as String;
          final minPoints = tier['minPoints'] as int;
          final maxPoints = tier['maxPoints'] as int;
          final benefits = tier['benefits'] as String;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isActive ? primaryColor.withOpacity(0.1) : Colors.white,
              border: Border.all(
                color: isActive ? primaryColor : lightGrayColor,
                width: isActive ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getTierIcon(tierName),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          tierName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isActive ? primaryColor : textColor,
                          ),
                        ),
                      ],
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '$minPoints - $maxPoints poin',
                  style: const TextStyle(
                    fontSize: 11,
                    color: darkGrayColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Benefit: $benefits',
                  style: const TextStyle(
                    fontSize: 11,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getBenefitIcon(String title) {
    if (title.contains('Reward')) {
      return Icons.card_giftcard;
    } else if (title.contains('Diskon')) {
      return Icons.local_offer;
    } else if (title.contains('Akses')) {
      return Icons.lock_open;
    } else if (title.contains('Gratis')) {
      return Icons.card_giftcard;
    }
    return Icons.star;
  }

  String _getTierIcon(String tierName) {
    switch (tierName) {
      case 'Bronze':
        return '🥉';
      case 'Silver':
        return '🥈';
      case 'Gold':
        return '🥇';
      case 'Platinum':
        return '💎';
      default:
        return '⭐';
    }
  }
}
