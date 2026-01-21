import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/buttons.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<FAQItem> faqs = [
    FAQItem(
      question: 'Bagaimana cara membuat pesanan?',
      answer:
          'Cukup cari restoran atau makanan yang Anda inginkan, tambahkan ke keranjang, dan lanjutkan ke checkout untuk menyelesaikan pesanan.',
      isExpanded: false,
    ),
    FAQItem(
      question: 'Berapa lama waktu pengiriman?',
      answer:
          'Waktu pengiriman rata-rata 30-45 menit tergantung dari jarak lokasi Anda ke restoran.',
      isExpanded: false,
    ),
    FAQItem(
      question: 'Bagaimana jika makanan tiba dalam kondisi rusak?',
      answer:
          'Anda dapat melaporkan masalah melalui aplikasi dan kami akan mengirimkan pengganti tanpa biaya tambahan.',
      isExpanded: false,
    ),
    FAQItem(
      question: 'Apakah ada biaya pengiriman?',
      answer:
          'Biaya pengiriman tergantung pada jarak pengiriman. Ada juga penawaran pengiriman gratis untuk pembelian di atas jumlah tertentu.',
      isExpanded: false,
    ),
    FAQItem(
      question: 'Bagaimana cara membatalkan pesanan?',
      answer:
          'Anda dapat membatalkan pesanan dalam 5 menit setelah pemesanan. Setelah itu, biaya pembatalan mungkin berlaku.',
      isExpanded: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: const Text(
          'Bantuan & Dukungan',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contact Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hubungi Kami',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ContactTile(
                          icon: Icons.phone_outlined,
                          title: 'Telepon',
                          subtitle: '+62 812 3456 7890',
                          onTap: () {},
                        ),
                        Divider(color: lightGrayColor, height: 0),
                        _ContactTile(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          subtitle: 'support@aliyadivani.com',
                          onTap: () {},
                        ),
                        Divider(color: lightGrayColor, height: 0),
                        _ContactTile(
                          icon: Icons.chat_outlined,
                          title: 'Chat',
                          subtitle: 'Chat dengan customer service',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pertanyaan yang Sering Diajukan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: faqs.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: lightGrayColor, height: 0),
                      itemBuilder: (context, index) {
                        final faq = faqs[index];
                        return ExpansionTile(
                          title: Text(
                            faq.question,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          collapsedBackgroundColor: Colors.white,
                          backgroundColor: lightGrayColor.withAlpha(128),
                          iconColor: primaryColor,
                          collapsedIconColor: darkGrayColor,
                          onExpansionChanged: (isExpanded) {
                            setState(() {
                              faq.isExpanded = isExpanded;
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                faq.answer,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: darkGrayColor,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Report Problem
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                label: 'Laporkan Masalah',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => _ReportProblemSheet(),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: darkGrayColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: darkGrayColor),
      onTap: onTap,
    );
  }
}

class _ReportProblemSheet extends StatefulWidget {
  @override
  State<_ReportProblemSheet> createState() => _ReportProblemSheetState();
}

class _ReportProblemSheetState extends State<_ReportProblemSheet> {
  final problemController = TextEditingController();
  String selectedCategory = 'Kualitas Makanan';

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporkan Masalah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kategori Masalah',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            items: [
              'Kualitas Makanan',
              'Pengiriman Terlambat',
              'Pesanan Salah',
              'Kurir Tidak Ramah',
              'Lainnya',
            ]
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() => selectedCategory = value!);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: lightGrayColor),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Deskripsi Masalah',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: problemController,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: lightGrayColor),
              ),
              hintText: 'Jelaskan masalah yang Anda alami',
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Kirim Laporan',
            onPressed: () {
              if (problemController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mohon jelaskan masalah Anda'),
                    backgroundColor: errorColor,
                  ),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan berhasil dikirim'),
                  backgroundColor: successColor,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
