import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class ReferralProgramScreen extends StatefulWidget {
  const ReferralProgramScreen({super.key});

  @override
  State<ReferralProgramScreen> createState() => _ReferralProgramScreenState();
}

class _ReferralProgramScreenState extends State<ReferralProgramScreen> {
  final String referralCode = 'ALIYA2024';
  bool copied = false;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
    setState(() => copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final referrals = [
      {'name': 'Ahmad Pratama', 'date': '10 Jan 2025', 'reward': 50000, 'status': 'Completed'},
      {'name': 'Siti Rahma', 'date': '8 Jan 2025', 'reward': 50000, 'status': 'Completed'},
      {'name': 'Budi Hermanto', 'date': '5 Jan 2025', 'reward': 50000, 'status': 'Pending'},
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Program Referral',
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
            // Referral Stats Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Bonus Referral',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rp 150,000',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Teman Bergabung',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '3 Teman',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status Bonus',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Rp 100k Cair',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // How It Works Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bagaimana Cara Kerjanya?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HowItWorksStep(
                    number: '1',
                    title: 'Bagikan Kode Referral',
                    description: 'Bagikan kode unik Anda ke teman dan keluarga',
                    icon: '📤',
                  ),
                  _HowItWorksStep(
                    number: '2',
                    title: 'Teman Bergabung',
                    description: 'Teman Anda mendaftar menggunakan kode Anda',
                    icon: '👥',
                  ),
                  _HowItWorksStep(
                    number: '3',
                    title: 'Teman Melakukan Pembelian',
                    description: 'Teman Anda melakukan pembelian pertama minimal Rp 50,000',
                    icon: '🛒',
                  ),
                  _HowItWorksStep(
                    number: '4',
                    title: 'Terima Bonus',
                    description: 'Anda mendapatkan bonus Rp 50,000 per referral',
                    icon: '💰',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Share Code Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: lightGrayColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kode Referral Saya',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          referralCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: _copyCode,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: copied ? successColor : primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              copied ? 'Tersalin!' : 'Salin',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur share akan datang...'),
                            backgroundColor: primaryColor,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text(
                        'Bagikan ke Teman',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Referral List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Teman yang Bergabung',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(
                      referrals.length,
                      (index) {
                        final referral = referrals[index];
                        final isCompleted = referral['status'] == 'Completed';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isCompleted ? successColor.withOpacity(0.3) : warningColor.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text('👤', style: TextStyle(fontSize: 24)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      referral['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                        referral['date'] as String,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: darkGrayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '+Rp ${referral['reward']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: successColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? successColor.withOpacity(0.1)
                                          : warningColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      referral['status'] as String,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted ? successColor : warningColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final String icon;

  const _HowItWorksStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          number,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
  }
}
